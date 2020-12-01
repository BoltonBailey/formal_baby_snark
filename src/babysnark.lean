
import data.mv_polynomial.basic
import data.polynomial.div


section 

universes v

variables {F : Type v}
variables [field F]


-- Variables for the theorem

inductive vars : Type
| X : vars
| Y : vars
| Z : vars

variables {m n l : ℕ}
-- NOTE: u is usually a universe variable in lean
-- here, u is a vector of polynomials
variable {u_stmt : vector (polynomial F) l}
variable {u_wit : vector (polynomial F) (n - l)}
variable {t : polynomial F}

-- TODO define u as the concatenation ("append" in lean)
-- of u_stmt and u_wit. This will require proof that 
-- l + (n-l) = n
-- def u : vector (polynomial F) n :=
-- u_stmt ++ u_wit


-- variables B_w V_w H : mv_polynomial vars F
-- variables b v h : vector F m
-- variables b_γ v_γ h_γ b_γβ v_γβ h_γβ : F
-- variables b' v' h' : vector F (n-l)

-- A stucture to hold the sample of three field elements from which the CRS is constructed
structure field_sample :=
mk :: (τ : F) (β : F) (γ : F) 

-- The structure to hold a CRS
structure crs :=
mk :: (τs : vector F m) (γ : F) (βγ : F) (βpolys : vector F (n-l)) 

structure proof :=
mk :: (H : F) (V_wit : F) (B_wit : F)

-- Vector form of range function
-- TODO ask mathlib maintainers to add this to mathlib
def vector_range (k : ℕ) : vector ℕ k :=
⟨list.range k, by simp⟩



def field_sample.setup (s : field_sample) (u_wit : vector (polynomial F) (n - l)) : crs 
:=
crs.mk 
    (vector.map (λ i, s.τ^i) (vector_range m)) 
    (s.γ) 
    (s.γ * s.β) 
    (vector.map (λ p : polynomial F, s.β * p.eval s.τ) u_wit)


def crs.prove (a_wit : vector F (n - l)) (a_stmt : vector F l) (u_stmt) (u_wit) (s : field_sample) : proof :=
let H : polynomial F := polynomial.div_by_monic 
                        (((vector.map₂ (λ a u, (polynomial.C a) * u) a_wit u_wit).to_list.sum + 
                          (vector.map₂ (λ a u, (polynomial.C a) * u) a_stmt u_stmt).to_list.sum
                              )^2 - 1) t
in
let V_wit : polynomial F := ((vector.map₂ (λ a u, (polynomial.C a) * u) a_wit u_wit).to_list.sum)
in      
let B_wit : polynomial F := ((vector.map₂ (λ a u, (polynomial.C a) * s.β * u) a_wit u_wit).to_list.sum)
in                       
proof.mk
    (polynomial.eval H s.τ)
    (polynomial.eval V_wit s.τ)
    (polynomial.eval B_wit s.τ)




-- def B_w : mv_polynomial vars F
-- :=
-- sorry


-- TODOs
-- define Prove function, taking crs and a
-- Define verify
-- NOTE: Currently we are not "in the exponent"


-- def X_monomial (n : ℕ) : mv_polynomial vars F
-- := 
-- mv_polynomial.monomial (finsupp.single var.X n) 1

-- crs_polynomials is a list of the polynomials X^0 , ... X^m, Z, YZ, Y u_i(X)
-- TODO it would be cleaner if u_i were single-variate polynomials
-- def crs_polynomials (u : list (mv_polynomial vars F)) : list (mv_polynomial vars F)
-- :=
-- list.map (λ n : ℕ, (mv_polynomial.X var.X) ^ n) (list.range m) 
-- ++
-- (mv_polynomial.X var.Z :: [])
-- ++
-- (mv_polynomial.X var.Y * mv_polynomial.X var.Z :: [])
-- ++
-- list.map (λ u_i : mv_polynomial vars F, mv_polynomial.X var.Y * u_i) (list.drop l u) 

-- -- The set of all polynomials of the form of 
-- #check crs_polynomials.to_set



-- theorem babysnark_knowledge_soundness : coeff


end