(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2018 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi
// Start Time: August, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
#staload
SYM = "./../SATS/symbol.sats"
#staload
MAP = "./../SATS/symmap.sats"
//
typedef sym_t = $SYM.sym_t
vtypedef
symmap(itm:type) = $MAP.symmap(itm)
//
(* ****** ****** *)

#staload "./../SATS/symenv.sats"

(* ****** ****** *)
//
vtypedef
symmaplst
(
  itm:type, n:int
) = list_vt(symmap(itm), n)
vtypedef
symmaplst
(itm:type) = [n:int] symmaplst(itm, n)
vtypedef
symmaplst0
(itm:type) = [n:nat] symmaplst(itm, n)
//
(* ****** ****** *)
//
fun
symmaplst_free
{itm:type}{n:nat} .<n>.
(xs: symmaplst(itm, n)): void =
(
  case+ xs of
  | ~list_vt_nil() => ()
  | ~list_vt_cons(x, xs) =>
     ($MAP.symmap_free(x); symmaplst_free(xs))
) // end of [symmaplst_free]
//
(* ****** ****** *)
//
fun
symmaplst_search
{itm:type}{n:nat} .<n>.
(
ms: !symmaplst(itm, n), k0: sym_t
) : Option_vt(itm) =
(
case+ ms of
| list_vt_nil
    () => None_vt()
  // list_vt_nil
| list_vt_cons
    (m1, ms2) => let
    val ans =
      $MAP.symmap_search(m1, k0)
    // end of [val]
  in
    case+ ans of
    | @Some_vt _ => ans where
      {
        prval () = fold@(ans)
      }
    | ~None_vt() => symmaplst_search(ms2, k0)
  end (* end of [list_vt_cons] *)
) (* end of [symmaplst_search] *)
//
(* ****** ****** *)

absimpl
symenv_vt0ype
  (itm:type) = @{
  map0= symmap(itm)
, maps= symmaplst0(itm)
, saved= List0_vt(@(symmap(itm), symmaplst(itm)))
, pervasive= symmap(itm)
} // end of [symenv_v0type]

(* ****** ****** *)

implement
symenv_make_nil
  {itm}((*void*)) =
  (pfat | p0) where
{
  vtypedef env_t = symenv(itm)
  val map0 = $MAP.symmap_make_nil()
  val (pfat, pfgc | p0) = ptr_alloc<env_t>()
//
  val () = p0->map0 := map0
  val () = p0->maps := list_vt_nil()
  val () = p0->saved := list_vt_nil()
  val () = p0->pervasive := $MAP.symmap_make_nil()
//
  prval() = mfree_gc_v_elim(pfgc)
//
} (* end of [symenv_make_nil] *)

(* ****** ****** *)

implement
symenv_search
{itm}(env, k0) = let
//
  val ans =
  $MAP.symmap_search(env.map0, k0)
//
in
  case+ ans of
  | ~None_vt() =>
    (
      symmaplst_search(env.maps, k0)
    )
  | @Some_vt _ =>
    (
      ans where { prval () = fold@(ans) }
    )
end // end of [symenv_search]

(* ****** ****** *)

implement
symenv_insert
{itm}(env, k0, x0) =
(
  $MAP.symmap_insert{itm}(env.map0, k0, x0)
) (* end of [symenv_insert] *)

(* ****** ****** *)

implement
symenv_insert2
{itm}(env, k0, x0, mix) =
(
  $MAP.symmap_insert2{itm}(env.map0, k0, x0, mix)
) (* end of [symenv_insert2] *)

(* ****** ****** *)

implement
symenv_pop
  (env) = map0 where
{
  val map0 = env.map0
  val-
 ~list_vt_cons
    (map1, maps) = env.maps
  // end of [val]
  val ((*void*)) = env.map0 := map1
  val ((*void*)) = env.maps := maps
} (* end of [symenv_pop] *)

implement
symenv_push
  (env, map0) = () where
{
//
val map1 = env.map0
val maps = env.maps
//
val ((*void*)) =
  (env.map0 := map0)
val ((*void*)) =
  (env.maps := list_vt_cons(map1, maps))
//
} (* end of [symenv_push] *)

(* ****** ****** *)
//
implement
symenv_pop_free
  (env) =
  $MAP.symmap_free(symenv_pop(env))
implement
symenv_push_nil
  (env) =
  symenv_push(env, $MAP.symmap_make_nil())
//
(* ****** ****** *)

(* end of [xats_symenv.dats] *)
