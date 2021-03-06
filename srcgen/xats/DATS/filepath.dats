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
// Start Time: May, 2018
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
  typedef symbol = $SYM.symbol
//
(* ****** ****** *)

#staload "./../SATS/filepath.sats"

(* ****** ****** *)

local

absimpl
filepath_type = $rec
{ filepath_kind= int
, filepath_givename= string
, filepath_partpath= string
, filepath_fullpath= symbol
} (* end of [filepath_type] *)

in (* in-of-local *)
//
implement
filepath_get_full
  (fp0) = fp0.filepath_fullpath
//
end // end of [local]

(* ****** ****** *)

local
//
#include
"./../sysparam.hats"
//
#if SYSTEM_IS_UNIX_LIKE #then
//
val theDirSep: char = '/'
val theCurDir: string = "./"
val theParDir: string = "../"
//
#endif

in (* in of [local] *)

implement theDirSep_get() = theDirSep
implement theCurDir_get() = theCurDir
implement theParDir_get() = theParDir

end // end of [local]

(* ****** ****** *)

local
//
%{^
typedef char *charptr;
%} (* %{^ *)
abstype
charptr = $extype"charptr"
//
in (* in-of-local *)
//
implement
filepath_dirbase
  (dir, base) = let
//
val
dir = g1ofg0(dir)
val
base = g1ofg0(base)
//
val n1 = length(dir)
val n2 = length(base)
//
val sep = theDirSep_get()
//
val sepd =
(
if
(n1 > 0)
then (dir[n1-1] = sep) else false
) : bool // end of [val]
//
val n12 = 
(
if sepd then (n1+n2+1) else (n1+n2+2)
) : Size_t // end of [val]
//
val dir = $UN.cast{charptr}(dir)
val base = $UN.cast{charptr}(base)
//
in
//
if
sepd
then let
  val
  (pf,fpf|p0) = malloc_gc(n12)
  val _(*n12*) =
  $extfcall(int, "sprintf", p0, "%s%s", dir, base)
in
  $UN.castvwtp0((pf, fpf | p0))
end // end of [then]
else let
  val
  (pf, fpf | p0) = malloc_gc(n12)
  val _(*n12*) =
  $extfcall(int, "sprintf", p0, "%s/%s", dir, base)
in
  $UN.castvwtp0((pf, fpf | p0))
end // end of [then]
//
end // end of [filepath_dirbase]

end // end of [local]

(* ****** ****** *)
//
implement
eq_filepath_filepath
  (x, y) = (compare(x, y) = 0)
implement
neq_filepath_filepath
  (x, y) = (compare(x, y) != 0)
//
(* ****** ****** *)

implement
compare_filepath_filepath
  (x1, x2) = let
//
val f1 =
$SYM.symbol_get_name(x1.full())
//
val f2 =
$SYM.symbol_get_name(x2.full())
//
in
  compare_string_string(f1, f2)
end // end of [compare_filepath_filepath]

(* ****** ****** *)

local

absreimpl filepath_type

in (* in-of-local *)

implement
the_filepath_dummy = $rec{
  filepath_kind= 0
, filepath_givename= ""
, filepath_partpath= ""
, filepath_fullpath= $SYM.symbol_nil
} // end of [the_filepath_dummy]

implement
the_filepath_stdin = $rec{
  filepath_kind= 0
, filepath_givename= "__STDIN__"
, filepath_partpath= "__STDIN__"
, filepath_fullpath= $SYM.STDIN_fp_symbol
} // end of [the_filepath_stdin]

implement
the_filepath_string = $rec{
  filepath_kind= 0
, filepath_givename= "__STRING__"
, filepath_partpath= "__STRING__"
, filepath_fullpath= $SYM.STRING_fp_symbol
} // end of [the_filepath_string]

implement
filepath_make
(
  given, pname, fname
) = let
//
val fname = $SYM.symbol_make(fname)
//
in '{
  filepath_kind= 0
, filepath_givename= given
, filepath_partpath= pname, filepath_fullpath= fname
} end // end of [filename_make]

end // end of [local]

(* ****** ****** *)
//
implement
filepath_is_dummy(fp) =
$SYM.eq_symbol_symbol
  (fp.full(), $SYM.symbol_nil)
implement
filepath_isnot_dummy(fp) =
$SYM.neq_symbol_symbol
  (fp.full(), $SYM.symbol_nil)
//
(* ****** ****** *)
//
implement
print_filepath_full
  (fp0) =
(
fprint_filepath_full(stdout_ref, fp0)
)
implement
prerr_filepath_full
  (fp0) =
(
fprint_filepath_full(stderr_ref, fp0)
)
implement
fprint_filepath_full
  (out, fp0) =
(
  fprint_string(out, sym)
) where
{
  val sym =
  $SYM.symbol_get_name(fp0.full((*void*)))
} (* end of [fprint_filepath_full] *)
//
(* ****** ****** *)

local
//
assume
the_filepathlst_v = unit_v
//
val
the_filepath =
ref<filepath>(the_filepath_dummy)
val
the_filepathlst =
ref<List0_vt(filepath)>(list_vt_nil())
//
in (* in-of-local *)

(* ****** ****** *)
//
implement
filepath_get_current
  ((*void*)) = the_filepath[]
//
(* ****** ****** *)

implement
the_filepathlst_pout
(
  pf | (*none*)
) = let
//
prval unit_v() = pf
//
in
  the_filepathlst_ppout((*void*))
end // end of [the_filepathlst_pout]

implement
the_filepathlst_ppout
  ((*none*)) = let
//
val fp = x0 where {
//
  val
  (vbox pf | p0) =
  ref_get_viewptr(the_filepathlst)
//
  val-
  ~list_vt_cons(x0, xs) = !p0
  val ((*void*)) = (!p0 := xs)
//
} (* end of [val] *)
//
val () = the_filepath[] := fp
//
in
  // nothing
end // end of [the_filepathlst_ppout]

(* ****** ****** *)
//
implement
the_filepathlst_push(fp) =
let
//
val () =
the_filepathlst_ppush(fp) in (unit_v() | ())
//
end // end of [the_filepathlst_push]
//
implement
the_filepathlst_ppush(fp) =
let
  val x0 = the_filepath[]
  val () = the_filepath[] := fp
  val (vbox pf | p0) = ref_get_viewptr(the_filepathlst)
  val () = !p0 := list_vt_cons(x0, !p0)
in
  // nothing
end // end of [the_filepathlst_ppush]
//
(* ****** ****** *)

local

fun
filename_occurs
  (fp0: filepath): bool = let
//
fun
loop
{n:nat} .<n>.
(
  fps: !list_vt(filepath, n)
) :<> bool = (
//
case+ fps of
| list_vt_nil
    ((*void*)) => false
  // list_vt_nil
| list_vt_cons
    (fp1, fps) =>
  (
    (fp0 = fp1) orelse loop(fps)
  ) // list_vt_cons
//
) (* end of [loop] *)
//
in
  loop(!p0) where
  {
    val (vbox(pf)|p0) =
    ref_get_viewptr(the_filepathlst)
  }
end // end of [filename_occurs]

in (* in-of-local *)

implement
the_filepathlst_pushck
  (fp0) =
(
  pf | isexi
) where
{
//
val
(pf|()) =
the_filepathlst_push(fp0)
val
isexi =
(
  if
  filepath_isnot_dummy(fp0)
  then filename_occurs(fp0) else false
) : bool // end of [val]
//
} (* end of [the_filepathlst_pushck] *)

end // end of [local]

(* ****** ****** *)

implement
the_filepath_fprint
  (out) =
(
 fprint_filepath_full(out, fp)
) where
{
  val fp = !p0 where
  {
  val (vbox(pf)|p0) =
  ref_get_viewptr(the_filepath)
  }
}
//
implement
the_filepathlst_fprint
  (out) = let
//
  val (vbox(pf)|p0) =
  ref_get_viewptr(the_filepathlst)
//
in
$effmask_ref
(
 list_vt_foreach<filepath>(!p0)
) where
{
implement
list_vt_foreach$fwork<filepath><void>
  (fp, env) = fprint_filepath_full(out, fp)
}
end // end of [the_filepathlst_fprint]
//
(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

(* end of [xats_filepath.dats] *)
