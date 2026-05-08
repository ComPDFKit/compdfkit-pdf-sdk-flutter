# Android Plugin Refactor Blueprint

## Document status

- Status: Draft
- Scope: Android plugin layer in `compdfkit_flutter`
- Goal: Rebuild the internal Android bridge structure without changing the public Dart API or MethodChannel protocol.

## Why this refactor is needed

The current Android plugin layer works, but the structure is already under sustained pressure.

The main issue is not file count or line count by itself. The real problem is that several bridge classes carry too many responsibilities at the same time:

- Channel dispatch
- Native SDK operations
- Data mapping
- File and Uri source resolving
- Activity and Fragment lifecycle wiring
- Viewer event bridging
- Document and view instance ownership

This creates three long-term risks:

1. A small feature change can spread across unrelated code paths.
2. Lifecycle bugs become hard to reason about because ownership is implicit.
3. Android bridge code becomes difficult to extend consistently.

The React Native Android layer already moved to a more structured model. Flutter should reuse the same architectural ideas, but it should still respect Flutter's MethodChannel and PlatformView lifecycle model.

## Refactor goals

This refactor should satisfy the following requirements:

1. Keep the public Dart API unchanged.
2. Keep existing MethodChannel names and method names unchanged.
3. Make document instances and viewer instances explicit and traceable.
4. Move business logic out of large switch-based plugin classes.
5. Keep PlatformView focused on native view and Fragment hosting.
6. Separate native operations from codec, mapper, and resolver logic.
7. Standardize error handling, threading, and cleanup behavior.

## Current structural issues

### 1. Entry lifecycle is incomplete

The root plugin currently wires the engine and activity successfully, but detach and config-change handling are thin. That makes cleanup and reattachment behavior harder to trust over time.

### 2. Plugin classes are too large

The current Android bridge is centered around three large plugins:

- `ComPDFKitSDKPlugin`
- `CPDFDocumentPlugin`
- `CPDFViewCtrlPlugin`

These classes mix routing, SDK calls, threading, serialization, and lifecycle integration in the same unit.

### 3. Ownership is implicit

`CPDFDocumentPlugin` can work with either a standalone `CPDFDocument` or a document obtained from a reader view. That means the effective source of truth is decided dynamically instead of structurally.

### 4. PlatformView is too close to bridge logic

The current PlatformView class does more than view hosting. It also participates directly in plugin setup and document/view control binding.

### 5. Utility classes are carrying domain responsibilities

Some current `utils` classes are not actually general-purpose utilities.

- `FileUtils` behaves like a document source resolver.
- `CPDFPageUtil` behaves like a page codec and annotation/widget bridge layer.

### 6. Error and threading behavior is inconsistent

The current codebase mixes:

- `result.success(false)`
- `result.error(...)`
- empty string fallbacks
- background-thread result completion
- silent exception swallowing

That inconsistency makes maintenance harder and complicates future testing.

## Target architecture

The Android layer should move to the following structure:

```text
android/src/main/java/com/compdfkit/flutter/compdfkit_flutter/
├── CompdfkitFlutterPlugin.java
├── constants/
│   └── CPDFConstants.java
├── bridge/
│   ├── BaseMethodChannelPlugin.java
│   ├── ChannelResult.java
│   ├── MethodRouter.java
│   └── ThreadDispatch.java
├── sdk/
│   ├── ComPDFKitSdkChannelPlugin.java
│   ├── SdkOps.java
│   ├── SdkActivityDelegate.java
│   └── SdkPluginRegistry.java
├── document/
│   ├── CPDFDocumentChannelPlugin.java
│   ├── CPDFDocumentContext.java
│   ├── CPDFDocumentRegistry.java
│   ├── ops/
│   │   ├── DocumentOpenOps.java
│   │   ├── DocumentSaveOps.java
│   │   ├── DocumentSecurityOps.java
│   │   ├── DocumentAnnotationOps.java
│   │   ├── DocumentWidgetOps.java
│   │   ├── DocumentOutlineOps.java
│   │   ├── DocumentBookmarkOps.java
│   │   ├── DocumentPageOps.java
│   │   ├── DocumentSearchOps.java
│   │   └── DocumentRenderOps.java
│   ├── codec/
│   │   ├── CPDFPageCodec.java
│   │   ├── annotation/
│   │   └── widget/
│   ├── mapper/
│   │   ├── CPDFDocumentInfoMapper.java
│   │   ├── CPDFBookmarkMapper.java
│   │   ├── CPDFOutlineMapper.java
│   │   ├── CPDFSearchResultMapper.java
│   │   └── CPDFEditAreaMapper.java
│   └── resolver/
│       └── CPDFDocumentSourceResolver.java
├── viewer/
│   ├── CPDFViewChannelPlugin.java
│   ├── CPDFViewContext.java
│   ├── CPDFViewRegistry.java
│   ├── ViewerEventDispatcher.java
│   ├── ViewerCustomEventBridge.java
│   └── ops/
│       ├── ViewerDisplayOps.java
│       ├── ViewerAnnotationOps.java
│       ├── ViewerEditorOps.java
│       ├── ViewerDialogOps.java
│       ├── ViewerStateOps.java
│       └── ViewerPreparationOps.java
├── platformview/
│   ├── CPDFPlatformView.java
│   ├── CPDFPlatformViewFactory.java
│   └── CPDFPlatformViewBinding.java
└── util/
    └── Only truly generic helpers remain here
```

## Layer responsibilities

### `bridge`

This layer owns bridge mechanics only.

Responsibilities:

- Base MethodChannel behavior
- Method routing
- Thread dispatch helpers
- Standardized result conversion

This layer must not know PDF domain details.

### `sdk`

This layer owns SDK-global behavior.

Responsibilities:

- SDK initialization
- SDK version queries
- font-related global operations
- file picker integration
- standalone document activity launch
- creation and registration of document plugins

This layer must not depend on viewer state.

### `document`

This layer owns document-scoped behavior.

Responsibilities:

- standalone `CPDFDocument` instances
- document open/save/security logic
- annotations and widgets at the document level
- outline and bookmark operations
- page manipulation and rendering
- search and info queries
- page/annotation/widget encoding
- source resolving for files, assets, and Uri inputs

If a feature works without an embedded reader UI, it belongs here.

### `viewer`

This layer owns embedded reader UI behavior.

Responsibilities:

- view-scoped state
- display and interaction settings
- annotation mode and editor mode changes
- viewer dialogs and transient UI
- event subscription filtering
- native viewer event dispatch to Flutter
- custom event bridging

If a feature requires `CPDFDocumentFragment`, `CPDFViewCtrl`, or `CPDFReaderView`, it belongs here.

### `platformview`

This layer owns only hosting.

Responsibilities:

- create native container view
- build Fragment arguments from creation params
- attach and detach `CPDFDocumentFragment`
- bind PlatformView lifecycle to viewer registration and cleanup

This layer should not own document business logic.

## Core design concepts

### Explicit context objects

The refactor should introduce explicit context objects instead of resolving state dynamically inside plugin methods.

#### `CPDFDocumentContext`

Suggested responsibilities:

- `documentUid`
- `CPDFDocument`
- optional `CPDFViewCtrl`
- optional `CPDFReaderView`
- `CPDFPageCodec`
- safe access helpers such as `requireDocument()`

This class stores state. It should not run business operations.

#### `CPDFViewContext`

Suggested responsibilities:

- `viewId`
- `CPDFDocumentFragment`
- `CPDFViewCtrl`
- `CPDFReaderView`
- linked `CPDFDocumentContext`
- subscribed event names

This class defines view ownership clearly. It should not become another large operations class.

### Registry-based ownership

Two registries should be introduced:

- `CPDFDocumentRegistry`
- `CPDFViewRegistry`

Each registry should support:

- register
- lookup
- unregister
- destroy/cleanup

This removes the current ambiguity around who owns which document or view instance.

### Operations as domain units

The large `switch (call.method)` pattern should be reduced to a thin routing layer.

Each domain operation class should:

- accept a context
- accept already-parsed inputs
- perform native SDK work
- return a value or throw a meaningful exception

The channel plugin should be reduced to:

1. Parse method inputs.
2. Resolve the correct context.
3. Delegate to an operation class.
4. Send the result through a standard bridge helper.

### Codec and mapper separation

The refactor should formalize the existing mapping work into dedicated types.

- `codec`: page-level annotation/widget encoding and decoding
- `mapper`: structured conversion to bridge maps and arrays
- `resolver`: source string resolution for files, assets, and content Uris

## Mapping from current classes to target structure

### `ComPDFKitSDKPlugin`

Move toward:

- `sdk/ComPDFKitSdkChannelPlugin.java`
- `sdk/SdkOps.java`
- `sdk/SdkActivityDelegate.java`

Suggested split:

- SDK init/version/fonts/import-font operations -> `SdkOps`
- file picker and activity result flow -> `SdkActivityDelegate`
- document plugin creation and registration -> registry-aware setup code

### `CPDFDocumentPlugin`

Move toward:

- `document/CPDFDocumentChannelPlugin.java`
- `document/CPDFDocumentContext.java`
- `document/ops/*`
- `document/codec/CPDFPageCodec.java`
- `document/resolver/CPDFDocumentSourceResolver.java`

Suggested split:

- open/close/import-document -> `DocumentOpenOps`
- save/saveAs -> `DocumentSaveOps`
- password/security -> `DocumentSecurityOps`
- annotations -> `DocumentAnnotationOps`
- widgets -> `DocumentWidgetOps`
- outline -> `DocumentOutlineOps`
- bookmarks -> `DocumentBookmarkOps`
- page operations -> `DocumentPageOps`
- search -> `DocumentSearchOps`
- render operations -> `DocumentRenderOps`

### `CPDFViewCtrlPlugin`

Move toward:

- `viewer/CPDFViewChannelPlugin.java`
- `viewer/CPDFViewContext.java`
- `viewer/ViewerEventDispatcher.java`
- `viewer/ViewerCustomEventBridge.java`
- `viewer/ops/*`

Suggested split:

- scale/background/margins/page display/preview mode -> `ViewerDisplayOps`
- annotation mode/default attributes/visibility/preparation -> `ViewerAnnotationOps`
- editor history/edit type/selection state -> `ViewerEditorOps`
- dialogs and auxiliary UI -> `ViewerDialogOps`
- event subscription and callback bridging -> `ViewerEventDispatcher`
- custom toolbar/context-menu/intercept events -> `ViewerCustomEventBridge`

### `CPDFViewCtrlFlutter`

Move toward:

- `platformview/CPDFPlatformView.java`
- `platformview/CPDFPlatformViewBinding.java`

Suggested responsibilities after refactor:

- create container view
- translate creation params into Fragment arguments
- attach fragment on view attach
- detach fragment on view detach or dispose
- notify registries during bind and unbind

### `FileUtils`

Move toward:

- `document/resolver/CPDFDocumentSourceResolver.java`

This class currently behaves like a bridge-specific document source resolver, not a general-purpose file utility.

### `CPDFPageUtil`

Move toward:

- `document/codec/CPDFPageCodec.java`

This class already acts like a page bridge codec and should be promoted to a first-class domain component.

## Implementation strategy

This refactor should be done incrementally. Do not attempt to land the full target structure in one change.

### Phase 1: Build the skeleton

Goal:

- Introduce the new package structure.
- Extract the most obvious shared components.
- Preserve behavior.

Recommended work:

- Add `document`, `viewer`, `sdk`, and `bridge` packages.
- Extract `CPDFDocumentSourceResolver` from current `FileUtils` usage.
- Extract `CPDFPageCodec` from current `CPDFPageUtil` usage.
- Introduce `CPDFDocumentContext` and `CPDFViewContext`.
- Introduce basic registries.

This phase should not change Dart-side behavior.

### Phase 2: Refactor document channel logic first

Goal:

- Reduce `CPDFDocumentPlugin` to a thin dispatch shell.

Recommended order:

1. `DocumentOpenOps`
2. `DocumentSaveOps`
3. `DocumentSecurityOps`
4. `DocumentAnnotationOps`
5. `DocumentWidgetOps`
6. `DocumentPageOps`
7. `DocumentSearchOps`
8. `DocumentRenderOps`
9. `DocumentOutlineOps`
10. `DocumentBookmarkOps`

Document-side refactoring should happen before viewer-side refactoring because it is lower risk and has fewer lifecycle dependencies.

### Phase 3: Refactor viewer channel logic

Goal:

- Split viewer operations from event dispatch and custom event bridging.

Recommended order:

1. Introduce `ViewerEventDispatcher`
2. Extract display and dialog operations
3. Extract annotation and editor operations
4. Extract custom event bridging
5. Reduce `CPDFViewCtrlPlugin` to routing and binding logic

### Phase 4: Normalize PlatformView hosting

Goal:

- Ensure PlatformView only hosts the native fragment and coordinates registration and cleanup.

Recommended work:

- move Fragment creation and hosting concerns into `platformview`
- define a clear attach/detach flow
- define a clear dispose flow
- handle config-change reattachment explicitly

### Phase 5: Standardize bridge behavior

Goal:

- Remove historical inconsistencies in result and threading behavior.

Recommended work:

- introduce a single result helper
- define when to use `error` vs `success(false)`
- define background-thread completion rules
- remove silent fallbacks where possible

## Recommended first implementation scope

The first actual code change should focus on the document side.

Recommended files to touch first:

- `plugin/CPDFDocumentPlugin.java`
- `utils/FileUtils.java`
- `utils/CPDFPageUtil.java`
- `plugin/BaseMethodChannelPlugin.java`
- `CompdfkitFlutterPlugin.java`

Recommended first deliverables:

1. Add `document/resolver/CPDFDocumentSourceResolver.java`
2. Add `document/codec/CPDFPageCodec.java`
3. Add `document/CPDFDocumentContext.java`
4. Add `document/CPDFDocumentRegistry.java`
5. Make `CPDFDocumentPlugin` delegate open/save/security logic into `document/ops`
6. Keep old channel names and method names intact

This is the lowest-risk entry point and creates the most leverage for later viewer refactoring.

## Do not do these things in the first pass

- Do not rename Dart APIs.
- Do not change MethodChannel names.
- Do not redesign the public parameter protocol.
- Do not refactor document and viewer layers at the same time.
- Do not start with cosmetic renaming across the entire Android package tree.

The first pass should prioritize correctness, ownership, and layering.

## Validation checklist

The refactor should be considered successful only if the following conditions are true:

1. A channel plugin no longer carries large amounts of native business logic.
2. Document instances and view instances can be explicitly traced through registries.
3. File, asset, and content Uri resolution is centralized.
4. Page, annotation, and widget bridge encoding is no longer mixed into action classes.
5. PlatformView cleanup no longer leaves hanging fragment, callback, or channel references.
6. New Android-side APIs can be placed into `sdk`, `document`, or `viewer` through a clear rule.

## Architecture decision summary

This refactor adopts the React Native Android layer's core strengths:

- thin entry points
- explicit instance context
- operation-based domain splitting
- codec and mapper separation

But it does not mirror the React Native codebase mechanically.

Flutter still needs an architecture that matches:

- `MethodChannel`
- `PlatformView`
- `Fragment` hosting
- Flutter engine and activity lifecycle

The target is not symmetry across repositories. The target is structural clarity with Flutter-specific correctness.

## Next step after this blueprint

The recommended next execution step is:

1. build the document skeleton
2. migrate document open/save/security logic first
3. stabilize ownership and cleanup
4. move to viewer refactoring only after document refactoring is settled