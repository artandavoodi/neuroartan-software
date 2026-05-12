---
type: Architecture
subtype: Model Registry Implementation

title: ICOS Model Registry Implementation Architecture
document_id: SW-ICOS-ARC-2026-0042

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Implementation Architecture"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"
  - "Legal Operations"

legal_sensitive: true
requires_gc_review: true
requires_creo_review: true
approval_status: Draft

gsa_protocol: "Pending Executive Validation"
gsa_approved: false

status: Active
lifecycle: Draft
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v1.6"
version: "2.2"

created_date: "2026-04-28"
last_updated: "2026-04-29"
last_reviewed: "2026-04-29"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Model Registry Layer"
  - "Model Resolution"
  - "Metadata Governance"
  - "Version Control"
  - "Ownership & Permissions"
  - "Discoverability"
  - "Provider-Agnostic Model Switching"
  - "Local / Cloud / Native Runtime Resolution"
  - "User-Created Model Registration"
  - "Training Lifecycle Binding"
  - "Legacy Runtime Exclusion"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/08 - Implementation Architecture/03 - Model Registry Architecture/01 - ICOS Model Registry Implementation Architecture.md"

related:
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/02 - API Gateway Architecture/01 - ICOS API Gateway Implementation Architecture.md"
  - "software/macos/08 - Software Direction/08 - Implementation Architecture/01 - Runtime Architecture/01 - ICOS Native Runtime Architecture.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"

tags:
  - "icos"
  - "model-registry"
  - "architecture"
  - "provider-routing"
  - "native-runtime"
  - "cloud-runtime"
  - "model-training"
---

## PURPOSE

Define the ICOS Model Registry as the single source of truth for all model ownership, resolution, metadata, and access control.

---

## CORE POSITION

No model exists without registry.

Runtime must never resolve models directly from filesystem.

Registry must act as the exclusive authority separating execution layer (inference), coordination layer (Supabase), and distribution layer (model delivery).

The registry must allow ICOS to switch between local models, native ICOS models, user-created models, trained derivative models, and optional cloud models through one governed runtime contract.

No model provider may be hardcoded into UI, prompt logic, session logic, gateway logic, or runtime execution paths.

---

## REGISTRY ROLE

The registry is responsible for:

- model identification
- metadata storage
- path resolution
- version control
- permission enforcement
- discoverability
- provider selection
- backend resolution
- runtime binding
- training lifecycle state
- model package compatibility
- local / cloud execution eligibility

---

## MODEL ENTITY

Each model must be represented as:

model_id (unique)

Required attributes:

- model_id
- name
- owner_id
- model_type (base / profile / system)
- storage_path
- version
- status (active / inactive / deprecated)
- provider_type (local / native / user_created / trained_derivative / cloud / future)
- backend_type (native / cloud / unavailable / future)
- package_format (native-package / converted-package / cloud-endpoint / future)
- runtime_binding
- training_state
- source_authority
- permission_state

---

## EXTENDED METADATA

Each model must include:

- training_state
- verification_state
- reliability_score
- discoverability_state
- interaction_mode
- permission_state
- provider_capabilities
- tokenizer_state
- weights_state
- inference_state
- streaming_state
- cloud_endpoint_state
- local_package_state
- training_lineage
- revocation_state

---

## VERSIONING MODEL

Each model version must:

- be immutable
- have separate storage path
- be independently addressable

No overwriting allowed.

---

## MODEL RESOLUTION

Resolution must follow:

1. request → model_id
2. lookup in registry
3. validate status
4. return storage_path + metadata

No fallback to filesystem search.

---

## PROVIDER RESOLUTION

Provider resolution must follow:

1. request → model_id
2. registry lookup
3. permission validation
4. provider_type resolution
5. backend_type resolution
6. package_format validation
7. runtime_binding creation
8. execution availability check

The runtime must receive only a resolved provider contract.

The runtime must not infer provider identity from file names, directory names, or legacy package markers.

---

## MODEL SWITCHING CONTRACT

Model switching must update the active runtime binding.

A valid switch must update:

- active model identifier
- active provider type
- active backend type
- active runtime binding
- active permission state
- active training state
- active UI model indicator
- active session model reference

UI-only switching is forbidden.

A model selector that changes display labels without changing runtime binding is invalid.

---

## LOCAL MODEL CONTRACT

Local models must be registered before use.

A local model registration must include:

- model_id
- owner_id
- storage path
- package format
- tokenizer availability
- weights availability
- backend compatibility
- permission state
- verification state

Local execution must remain modular and must not depend on external runtime systems.

---

## NATIVE ICOS MODEL CONTRACT

Native ICOS models must use ICOS-compatible package structure.

Required native package components include:

- config.json
- tokenizer.json
- weights file or merged weight package
- manifest
- runtime compatibility metadata
- inference backend compatibility metadata

Native ICOS models must not be represented by partial fragments, temporary shards, or unverified legacy package layouts.

---

## CLOUD MODEL CONTRACT

Cloud models must be registered as provider contracts.

A cloud model registration must include:

- provider identifier
- endpoint authority
- authentication boundary
- permission state
- data-retention policy state
- latency state
- availability state
- fallback prohibition state

Cloud execution is optional.

Cloud execution must operate through external inference infrastructure (GPU servers, endpoints, or dedicated runtime services). Supabase must not be used as a model execution engine.

Cloud execution must never replace local/native architecture or create dependency lock.

---

## USER-CREATED MODEL CONTRACT

User-created models must be governed by registry before training or execution.

A user-created model record must include:

- owner identity
- source authorization
- training consent state
- data boundary
- training status
- verification status
- visibility status
- interaction permission state
- deletion / revocation pathway

User-created models must never bypass registry governance.

---

## TRAINING LIFECYCLE CONTRACT

Training state must be explicit and registry-bound.

Supported states include:

- untrained
- configured
- training_pending
- training_active
- training_paused
- trained
- verified_trained
- revoked

Training must bind to source authorization, privacy controls, model ownership, and permission state.

Training must not be treated as a simple UI action.

---

## LEGACY EXCLUSION CONTRACT

Legacy runtime names, dependency paths, and package assumptions must not exist in active execution logic.

Legacy provenance may exist only as historical migration metadata.

Any inherited model package must be converted into an ICOS-compatible native package before active registration.

The registry must reject partial shards, unverified fragments, and runtime-dependent package layouts.

---

## OWNERSHIP

Each model must have:

- owner_id
- ownership proof (if external)

Ownership must be enforced in access control.

---

## PERMISSION LAYER

Registry must enforce:

- private models
- public models
- restricted models

Permissions must be checked before access.

---

## DISCOVERABILITY

Registry must support:

- searchable models
- non-searchable models

Discoverability must be independent from visibility.

---

## REGISTRY–RUNTIME CONTRACT

Runtime must:

- request model via registry
- receive resolved path + metadata

Runtime must not bypass registry.

Runtime must execute through a resolved provider contract.

Execution must remain isolated from coordination systems such as Supabase and must not depend on storage-layer services for inference.

Runtime must not hardcode model identifiers, provider identifiers, package paths, or cloud endpoints.

---

## REGISTRY–GATEWAY CONTRACT

Gateway must:

- query registry for model selection
- enforce permission rules

---

## CONSISTENCY GUARANTEE

Registry must ensure:

- no orphan models
- no duplicate IDs
- alignment with storage layer
- alignment with provider layer
- alignment with runtime binding
- alignment with training lifecycle state
- alignment with permission state

Continuous validation required.

---

## STORAGE BINDING

Registry must map:

model_id → absolute storage path

Paths must be deterministic.

---

## FAILURE CONDITION

Models are resolved outside registry or metadata becomes inconsistent.

Provider selection is hardcoded, model switching changes only UI labels, user-created models bypass registry, training state is not governed, or legacy runtime assumptions enter active execution.

---

## SUCCESS CONDITION

Registry becomes the authoritative control layer for all models, ensuring deterministic resolution, provider switching, runtime binding, ownership governance, training lifecycle control, local/cloud execution separation, and traceability.

---

## Change Log

- 2026-04-29 — v2.2 Runtime layer separation enforced. Registry updated to explicitly separate execution (inference), coordination (Supabase), and distribution layers. Cloud execution defined as external inference infrastructure, not Supabase runtime. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: ICOS runtime and registry alignment during model installation phase.
- 2026-04-28 — v2.1 Provider-agnostic switching, local/native/cloud runtime contracts, user-created model registration, training lifecycle binding, and legacy runtime exclusion added. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: ICOS model registry architecture rebuild after runtime contamination repair.
- 2026-04-28 — v2.0 Model registry architecture defined with ownership, metadata, versioning, and resolution rules. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Implementation architecture expansion.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.2

---

END OF DOCUMENT