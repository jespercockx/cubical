{-# OPTIONS --safe #-}
module Cubical.Data.FinData.Base where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function

import Cubical.Data.Empty as ⊥
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Bool.Base
open import Cubical.Relation.Nullary

private
  variable
    ℓ : Level
    A B : Type ℓ

data Fin : ℕ → Type₀ where
  zero : {n : ℕ} → Fin (suc n)
  suc  : {n : ℕ} (i : Fin n) → Fin (suc n)

toℕ : ∀ {n} → Fin n → ℕ
toℕ zero    = 0
toℕ (suc i) = suc (toℕ i)

fromℕ : (n : ℕ) → Fin (suc n)
fromℕ zero    = zero
fromℕ (suc n) = suc (fromℕ n)

¬Fin0 : ¬ Fin 0
¬Fin0 ()

_==_ : ∀ {n} → Fin n → Fin n → Bool
zero == zero   = true
zero == suc _  = false
suc _ == zero  = false
suc m == suc n = m == n

predFin : {n : ℕ} → Fin (suc (suc n)) → Fin (suc n)
predFin zero = zero
predFin (suc x) = x

foldrFin : ∀ {n} → (A → B → B) → B → (Fin n → A) → B
foldrFin {n = zero}  _ b _ = b
foldrFin {n = suc n} f b l = f (l zero) (foldrFin f b (l ∘ suc))

elim
  : ∀(P : ∀{k} → Fin k → Type ℓ)
  → (∀{k} → P {suc k} zero)
  → (∀{k} → {fn : Fin k} → P fn → P (suc fn))
  → {k : ℕ} → (fn : Fin k) → P fn

elim P fz fs {zero} = ⊥.rec ∘ ¬Fin0
elim P fz fs {suc k} zero = fz
elim P fz fs {suc k} (suc fj) = fs (elim P fz fs fj)


rec : ∀{k} → (a0 aS : A) → Fin k → A
rec a0 aS zero = a0
rec a0 aS (suc x) = aS
