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
// Start Time: June, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#staload
UN =
"prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
#staload
"./../SATS/label0.sats"
#staload
"./../SATS/location.sats"
//
#staload "./../SATS/lexing.sats"
#staload "./../SATS/staexp0.sats"
//
(* ****** ****** *)

local

absimpl
i0nt_tbox = $rec{
  i0nt_loc= loc_t
, i0nt_node= i0nt_node
} (* end of [absimpl] *)
absimpl
c0har_tbox = $rec{
  c0har_loc= loc_t
, c0har_node= c0har_node
} (* end of [absimpl] *)
//
absimpl
i0dnt_tbox = $rec{
  i0dnt_loc= loc_t
, i0dnt_node= i0dnt_node
} (* end of [absimpl] *)

in (* in-of-local *)

(* ****** ****** *)

fun
i0nt_make_node
(
loc0: loc_t
,
node: i0nt_node
) : i0nt = $rec{
  i0nt_loc= loc0, i0nt_node= node
} (* end of [i0nt_make_node] *)

fun
c0har_make_node
(
loc0: loc_t
,
node: c0har_node
) : c0har = $rec{
  c0har_loc= loc0, c0har_node= node
} (* end of [c0har_make_node] *)

(* ****** ****** *)

fun
i0dnt_make_node
(
loc0: loc_t
,
node: i0dnt_node
) : i0dnt = $rec{
  i0dnt_loc= loc0, i0dnt_node= node
} (* end of [i0dnt_make_node] *)

(* ****** ****** *)

implement
i0nt_get_loc(x) = x.i0nt_loc
implement
i0nt_get_node(x) = x.i0nt_node

implement
c0har_get_loc(x) = x.c0har_loc
implement
c0har_get_node(x) = x.c0har_node

(* ****** ****** *)

implement
i0dnt_get_loc(x) = x.i0dnt_loc
implement
i0dnt_get_node(x) = x.i0dnt_node

(* ****** ****** *)

implement
i0nt_none(tok) =
i0nt_make_node(tok.loc(), I0NTnone(tok))
implement
i0nt_some(tok) =
i0nt_make_node(tok.loc(), I0NTsome(tok))

(* ****** ****** *)

implement
c0har_none(tok) =
c0har_make_node(tok.loc(), C0HARnone(tok))
implement
c0har_some(tok) =
c0har_make_node(tok.loc(), C0HARsome(tok))

(* ****** ****** *)

implement
i0dnt_some(tok) =
i0dnt_make_node(tok.loc(), I0DNTsome(tok))
implement
i0dnt_none(tok) =
i0dnt_make_node(tok.loc(), I0DNTnone(tok))

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

local

absimpl
sort0_tbox = $rec{
  sort0_loc= loc_t
, sort0_node= sort0_node
} (* end of [absimpl] *)

in (* in-of-local *)

implement
sort0_get_loc(x) = x.sort0_loc
implement
sort0_get_node(x) = x.sort0_node

implement
sort0_make_node
(loc, node) = $rec
{
  sort0_loc= loc, sort0_node= node
} (* end of [sort0_make_node] *)

end // end of [local]

(* ****** ****** *)

local

absimpl
l0abl_tbox = $rec{
//
  l0abl_loc= loc_t
,
  l0abl_lab= label
//
} (* end of [absimpl] *)

in (* in-of-local *)

implement
l0abl_make
  (loc, lab) = $rec{
  l0abl_loc= loc, l0abl_lab= lab
} (* end of [l0abl_make] *)

implement
l0abl_get_loc(l0) = l0.l0abl_loc
implement
l0abl_get_lab(l0) = l0.l0abl_lab

end // end of [local]

(* ****** ****** *)
//
implement
print_l0abl
  (l0) = fprint_l0abl(stdout_ref, l0)
implement
prerr_l0abl
  (l0) = fprint_l0abl(stderr_ref, l0)
implement
fprint_l0abl
  (out, l0) = $LAB.fprint_label(out, l0.lab())
//
(* ****** ****** *)

local

absimpl
s0exp_tbox = $rec{
  s0exp_loc= loc_t
, s0exp_node= s0exp_node
} (* end of [absimpl] *)

in (* in-of-local *)

(* ****** ****** *)

implement
s0exp_get_loc(x) = x.s0exp_loc
implement
s0exp_get_node(x) = x.s0exp_node

implement
s0exp_make_node
(loc, node) = $rec
{
  s0exp_loc= loc, s0exp_node= node
} (* end of [s0exp_make_node] *)

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)
//
implement
s0exp_RPAREN_loc(x0) =
(
case+ x0 of
| s0exp_RPAREN_cons0
    (tok) => tok.loc()
  // s0exp_RPAREN_cons0
| s0exp_RPAREN_cons1
    (tok1, s0es, tok2) => tok1.loc() + tok2.loc()
  // s0exp_RPAREN_cons1
)  
//
(* ****** ****** *)

(* end of [xats_staexp0.dats] *)
