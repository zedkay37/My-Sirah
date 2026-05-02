# Action Review V2

Status: internal editorial review support.

This document is not loaded by the app. It exists to review the action bank in `assets/data/name_actions.json` before any action is promoted from `needs_review` to `validated`.

## Review Rules

- Do not mark an action `validated` without human review.
- A validated action must include `reviewedBy`, `validatedAt`, and either `sourceNote` or `sourceRefs`.
- Keep actions sober, practical, non-performative, and non-coercive.
- Prefer rewriting or removing an action if the link to the name or constellation feels weak.
- Do not use `general` as a user-facing fallback. It remains a guardrail bank unless a specific product decision changes that.

## Decision Values

Use one of these during review:

| Decision | Meaning |
| --- | --- |
| `keep` | Text is acceptable after source/justification is added. |
| `rewrite` | Intention is acceptable, wording needs work. |
| `remove` | Action is too weak, too vague, or not appropriate. |
| `validated` | Ready to promote in JSON with review metadata. |

## Review Progress

Validated waves:

1. `praise`, `mission`, `light`
2. `trust`, `nobility`, `virtues`
3. `intercession`, `eschatology`, `purity`, `miraj`, `guidance`, `devotion`

All constellation action groups are now reviewed. `general` remains a non-user-facing guardrail bank.

## Review Matrix

### Général / garde-fou (`general`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `general_intention_001` | Commence une action simple avec une intention claire. | Garde-fou | À relire |  |  |
| `general_speech_001` | Adresse une parole utile et douce à quelqu'un. | Garde-fou | À relire |  |  |
| `general_gratitude_001` | Prends un moment court pour remercier Allah avec présence. | Garde-fou | À relire |  |  |

### Louange (`praise`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `praise_gratitude_001` | Remercie explicitement quelqu'un pour un bien reçu. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la louange. | Lot pilote. |
| `praise_gratitude_002` | Transforme une plainte en une parole de gratitude. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la louange. | Lot pilote. |
| `praise_gratitude_003` | Mentionne une bénédiction précise dans ta journée. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la louange. | Lot pilote. |
| `praise_name_001` | Associe le nom étudié à une parole de reconnaissance sincère. | Nom 1 | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au nom 1 et à la louange. | Lot pilote, action liée au nom. |

### Prophétie Et Mission (`mission`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `mission_teaching_001` | Applique aujourd'hui un enseignement prophétique concret. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la mission prophétique. | Lot pilote. |
| `mission_speech_001` | Partage une parole bénéfique sans débat ni dureté. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la mission prophétique. | Lot pilote. |
| `mission_intention_001` | Choisis une action qui clarifie ton intention. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la mission prophétique. | Lot pilote. |
| `mission_name_005` | Relie une décision du jour à l'idée de transmission responsable. | Nom 5 | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au nom 5 et à la mission prophétique. | Lot pilote, action liée au nom. |

### Confiance / Véracité (`trust`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `trust_promise_001` | Tiens une promesse, même petite. | Thème action | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la confiance et à la véracité. | Deuxième vague. |
| `trust_speech_001` | Évite une exagération dans ta parole aujourd'hui. | Thème action | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la confiance et à la véracité. | Deuxième vague. |
| `trust_deposit_001` | Rends quelque chose confié avec soin. | Thème action | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la confiance et à la véracité. | Deuxième vague. |
| `trust_name_021` | Choisis une parole parfaitement vraie, dite avec douceur. | Nom 21 | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au nom 21 et à la véracité. | Deuxième vague, action liée au nom. |

### Origine Noble (`nobility`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `nobility_family_001` | Honore un lien familial par un message simple. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'origine noble et à la dignité relationnelle. | Deuxième vague. |
| `nobility_response_001` | Réponds avec dignité là où tu pourrais réagir trop vite. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'origine noble et à la dignité relationnelle. | Deuxième vague. |
| `nobility_discretion_001` | Fais une petite action discrète pour préserver l'honneur de quelqu'un. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'origine noble et à la dignité relationnelle. | Deuxième vague. |
| `nobility_name_078` | Pose un geste de respect envers un lien de famille ou de proximité. | Nom 78 | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au nom 78 et à la noblesse relationnelle. | Deuxième vague, action liée au nom. |

### Rang Divin Et Intercession (`intercession`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `intercession_dua_001` | Fais une invocation discrète pour quelqu'un qui traverse une difficulté. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'intercession et à la miséricorde. | Troisième vague. |
| `intercession_mercy_001` | Cherche une manière de faciliter la charge d'une personne aujourd'hui. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'intercession et à la miséricorde. | Troisième vague. |
| `intercession_reconciliation_001` | Si cela est juste et possible, fais un pas discret vers l'apaisement d'une relation abîmée. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à l'intercession et à la miséricorde. | Troisième vague, formulation adoucie. |

### Eschatologie (`eschatology`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `eschatology_accounting_001` | Prends deux minutes pour revoir une action du jour avec sincérité. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au rappel de l'au-delà et à la responsabilité. | Troisième vague. |
| `eschatology_priority_001` | Renonce à une distraction pour protéger un bien plus important. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au rappel de l'au-delà et à la responsabilité. | Troisième vague. |
| `eschatology_repair_001` | Répare aujourd'hui une petite négligence avant qu'elle ne s'installe. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au rappel de l'au-delà et à la responsabilité. | Troisième vague. |

### Pureté Et Sainteté (`purity`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `purity_cleanliness_001` | Soigne un espace que tu utilises souvent, même modestement. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la pureté et à la tazkiya. | Troisième vague. |
| `purity_intention_001` | Avant une action habituelle, rectifie ton intention en silence. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la pureté et à la tazkiya. | Troisième vague. |
| `purity_speech_001` | Retire de ta parole une moquerie, une plainte ou une dureté inutile. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la pureté et à la tazkiya. | Troisième vague. |

### Qualités Morales (`virtues`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `virtues_truth_001` | Dis une vérité utile sans dureté ni mise en scène. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée aux qualités morales. | Deuxième vague. |
| `virtues_patience_001` | Accueille un contretemps sans réponse brusque. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée aux qualités morales. | Deuxième vague. |
| `virtues_mercy_001` | Choisis une réponse qui préserve la personne autant que la vérité. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée aux qualités morales. | Deuxième vague. |

### Voyage Nocturne (Miʿrāj) (`miraj`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `miraj_prayer_001` | Accorde plus de calme et de présence à une prière obligatoire. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au Mi'raj et à la présence dans la prière. | Troisième vague. |
| `miraj_presence_001` | Avant de commencer une prière, marque une pause consciente. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au Mi'raj et à la présence dans la prière. | Troisième vague. |
| `miraj_return_001` | Après une prière, choisis une action concrète qui en prolonge la présence. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée au Mi'raj et à la présence dans la prière. | Troisième vague. |

### Attributs De Guidance (`guidance`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `guidance_learning_001` | Apprends un détail fiable sur le nom exploré aujourd'hui. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la guidance et à l'apprentissage fiable. | Troisième vague. |
| `guidance_help_001` | Aide quelqu'un à clarifier une bonne action possible. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la guidance et à l'apprentissage fiable. | Troisième vague. |
| `guidance_question_001` | Pose une question sincère à une personne de confiance pour mieux agir. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la guidance et à l'apprentissage fiable. | Troisième vague. |

### Beauté Et Lumière (`light`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `light_smile_001` | Apporte de la douceur visible dans une rencontre ordinaire. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la beauté et à la lumière. | Lot pilote. |
| `light_clarity_001` | Clarifie une parole confuse avant qu'elle ne blesse ou n'éloigne. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la beauté et à la lumière. | Lot pilote. |
| `light_presence_001` | Rends une présence plus lumineuse par une attention réelle à l'autre. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la beauté et à la lumière. | Lot pilote. |

### Dévotion Et Adoration (`devotion`)
| Action ID | Texte actuel | Portée | Décision | Source / justification | Notes |
| --- | --- | --- | --- | --- | --- |
| `devotion_worship_001` | Choisis une adoration courte et accomplis-la sans précipitation. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la dévotion et à l'adoration. | Troisième vague. |
| `devotion_consistency_001` | Répète une petite bonne action avec constance aujourd'hui. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la dévotion et à l'adoration. | Troisième vague. |
| `devotion_hidden_001` | Garde une bonne action entre Allah et toi, sans l'exposer. | Constellation | `validated` | Revue humaine utilisateur 2026-04-30 ; invitation pratique liée à la dévotion et à l'adoration. | Troisième vague, non performatif. |
