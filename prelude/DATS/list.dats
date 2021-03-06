(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Xanadu - Unleashing the Potential of Types!
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
// Start Time: October, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)

primplmnt
(*nonrec*)
lemma_list_param
  (xs) =
(
//
case+ xs of
| list_nil _ => ()
| list_cons _ => ()
//
) (* lemma_list_param *)

(* ****** ****** *)

implement
<x><n>
list_tabulate(n0) =
(
let
var r0: ptr?
val () = auxlst(0, r0) in r0
endlet
) where
{
fun
auxlst
{ i:nat
| i <= n}
(
i0: sint(i)
,
r0: ptr? >>
    list_vt(x0, n-i)
) : void =
(
if
(i0 < n0)
then let
//
val x0 =
list_tabulate$fopr
<x><n>(i0)
//
val r0 =
list_vt_cons(x0, ?)
val+
list_vt_cons(_, r1) = r0
//
in
  auxlst(i0+1, r1); fold@(r0)
end // end of [then]
else (r0 := list_vt_nil())
)
}

(* ****** ****** *)

(* end of [list.dats] *)
