(*---------------------------------------------------------------------------
   Copyright (c) 2020 The ipaddr_ext programmers. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

module Int32_helper = struct
  let bit_set i n = (Int32.logand i (Int32.shift_left 1l n)) <> 0l

  let to_bit_string (i : Int32.t) : string =
    let b = Bytes.make 32 '0' in 
    for n = 31 downto 0; do
      if bit_set i n then Bytes.set b (31 - n) '1'
    done;
    Bytes.to_string b
end

module V4 = struct
  open Ipaddr

  let to_bit_string a = a |> V4.to_int32 |> Int32_helper.to_bit_string

  module Prefix = struct
    let subnets_to_seq prefix_len (prefix : V4.Prefix.t) : V4.Prefix.t Seq.t =
      let rec init_seq start stop steps prefix_len =
        if start >= stop then Seq.Nil
        else (
          let net_addr = V4.of_int32 start in
          let prefix = V4.Prefix.make prefix_len net_addr in
          let start_addr = (Int32.add start steps) in
          Seq.Cons (prefix, (fun () -> init_seq start_addr stop steps prefix_len)))
      in
      if V4.Prefix.bits prefix > prefix_len || prefix_len > 32
      then fun () -> Seq.Nil
      else (let steps = CCInt32.pow 2l (32 - prefix_len |> Int32.of_int) in
        let start_addr = V4.Prefix.network prefix |> V4.to_int32 in
        let stop_addr = V4.Prefix.broadcast prefix |> V4.to_int32 in
        fun () -> init_seq start_addr stop_addr steps prefix_len)
  end
end

module V6 = struct
  let to_bit_string a =
    let p1, p2, p3, p4 = Ipaddr.V6.to_int32 a in
    Int32_helper.to_bit_string p1 ^
    Int32_helper.to_bit_string p2 ^
    Int32_helper.to_bit_string p3 ^
    Int32_helper.to_bit_string p4
end

(*---------------------------------------------------------------------------
   Copyright (c) 2020 The ipaddr_ext programmers
   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.
   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
