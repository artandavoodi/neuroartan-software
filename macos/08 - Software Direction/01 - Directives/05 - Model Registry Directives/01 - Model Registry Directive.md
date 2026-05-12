---
type: Directive
subtype: Model Registry Directive

title: ICOS Model Registry Directive
document_id: SW-ICOS-DIR-2026-0002

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Model Registry Directives"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"

legal_sensitive: false
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
version: "2.1"

created_date: "2026-04-28"
last_updated: "2026-04-28"
last_reviewed: "2026-04-28"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "ICOS Model Registry Architecture"
  - "Model Governance"
  - "Model Routing Enforcement"
  - "Discoverability & Verification"
  - "Permission-Bound Model Access"
  - "Provider-Agnostic Model Switching"
  - "User-Created Model Registration"
  - "Training Lifecycle Governance"
  - "Local / Cloud / Native Runtime Provider Control"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/01 - Directives/05 - Model Registry Directives/01 - Model Registry Directive.md"

related:
  - "software/macos/08 - Software Direction/00 - Index & Control/00 - Master Control/00 - Software Direction Master Control.md"
  - "I/02 - Operations/01 - Executive Command/04 - Product Vision Core (Neuroartan)/01 - Product Definition/01 - Core Definitions/06 - ICOS Model Registry, Verification & Discoverability System.md"

tags:
  - "icos"
  - "model-registry"
  - "software-direction"
  - "provider-routing"
  - "native-runtime"
  - "model-training"
---

## PURPOSE

Define the canonical structure, behavior, and governance of the ICOS Model Registry as a core system layer.

---

## CORE POSITION

The Model Registry is not a UI listing.

The Model Registry is a governed system that controls:

- model identity
- model routing
- model visibility
- model permissions
- model verification

The Model Registry is the authority layer that allows ICOS to switch between local models, native ICOS models, user-created models, trained derivative models, and optional cloud models without hardcoding, runtime duplication, or dependency lock.

---

## MODEL REGISTRY REQUIREMENT

Every model must exist as a governed object.

No model may exist as a UI-only construct.

---

## MODEL STRUCTURE

Each model must contain:

- owner
- model type
- training state
- verification state
- visibility state
- discoverability state
- interaction permission
- reliability state
- legacy eligibility
  - provider type
  - backend type
  - runtime compatibility
  - package format
  - source authority
  - training lineage
  - active runtime binding

---

## MODEL STATES

System must distinguish:

- private
- public (non-searchable)
- public searchable
- searchable non-interactable
- searchable interactable
- permission-limited
- legacy-enabled

States must be independent.

---

## MODEL ROUTING RULE

Model selection must:

- switch real runtime engine
- bind to session
- update system state
- reflect in UI indicators

UI-only switching is forbidden.

---

## PROVIDER ABSTRACTION RULE

ICOS must support model execution through provider-bound runtime layers.

Supported provider classes include:

- local model provider
- native ICOS model provider
- user-created model provider
- trained derivative model provider
- cloud model provider
- future provider

Provider selection must occur through the Model Registry and runtime provider resolver.

No provider may be hardcoded into UI, prompt logic, console logic, or session logic.

---

## MODEL SWITCHING RULE

Model switching must change the active runtime binding.

Every model switch must update:

- active model identifier
- provider type
- backend type
- runtime session binding
- permission state
- training state
- UI model indicator

A model selector that changes labels without changing runtime binding is forbidden.

---

## USER-CREATED MODEL RULE

Users must be able to create and register governed models.

User-created models must include:

- owner identity
- source permissions
- training consent state
- source data boundary
- training status
- verification status
- visibility status
- interaction permission state
- deletion / revocation pathway

User-created models must not bypass registry governance.

---

## TRAINING LIFECYCLE RULE

Training is a governed lifecycle, not a UI action.

The system must distinguish:

- untrained model
- configured model
- training pending
- training active
- training paused
- trained model
- verified trained model
- revoked model

Training state must bind to source authorization, privacy controls, model ownership, and registry status.

---

## LOCAL / CLOUD EXECUTION RULE

ICOS must support both local and cloud execution without changing the app-layer contract.

The app must call one abstract runtime interface.

The runtime must resolve:

- selected model
- provider
- backend
- package format
- execution availability
- permission state

Cloud execution is optional and must remain modular.

Local execution is mandatory for sovereign runtime development.

---

## LEGACY EXCLUSION RULE

Legacy dependency names, package assumptions, and execution paths must not exist inside active runtime logic.

Any model package inherited from a legacy source must be converted into an ICOS-compatible native package before registration.

The registry may preserve migration provenance only as historical metadata.

Legacy runtime systems must never become active dependencies.

---

## DISCOVERABILITY RULE

Search must prioritize:

- verified models
- higher reliability models
- permitted models

Unverified or restricted models must not surface incorrectly.

---

## VERIFICATION RULE

Verification is trust infrastructure.

System must support:

- verification states
- verification signals
- revocation

Verification must never be cosmetic.

---

## PERMISSION RULE

Model access must be governed by:

- ownership
- visibility
- interaction permission
- subscription entitlement

These must not be merged.

---

## ENTITLEMENT BINDING

Model creation and usage must bind to:

- plan limits
- creation slots
- feature access

Entitlement is system governance, not billing display.

---

## DASHBOARD BINDING

Model Registry must connect to:

- model dashboard
- analytics
- knowledge graph
- training state
- source data

---

## ABUSE CONTROL

System must include:

- creation limits
- impersonation protection
- misuse detection
- revocation ability

---

## SOFTWARE RULE

The registry must exist as a core data layer.

No duplicated logic.

No UI-only representations.

No hardcoded model identifiers.

No fixed provider assumptions.

No runtime-specific dependency lock.

No placeholder execution.

No echo-based model behavior.

---

## SUCCESS CONDITION

Model registry drives:

- routing
- provider selection
- runtime binding
- local execution
- cloud execution
- user-created model registration
- training lifecycle control
- search
- trust
- access

---

## Change Log

- 2026-04-28 — v2.1 Provider-agnostic model switching, user-created model registration, training lifecycle governance, local/cloud execution separation, and legacy runtime exclusion added. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: ICOS runtime architecture correction and model registry hardening.

- 2026-04-28 — v2.0 Full directive hardening based on product definition audit; added model states, routing enforcement, verification, entitlement binding, and registry integration. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Software direction system binding.
- 2026-04-28 — v1.0 Initial directive created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.1

---

END OF DOCUMENT