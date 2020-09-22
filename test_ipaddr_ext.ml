(*---------------------------------------------------------------------------
   Copyright (c) 2020 The ipaddr_ext programmers. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

let test_to_bit_string () =
  Alcotest.(check string) "bit conversion" "11000000101010000000000000000001"
    (Ipaddr_ext.V4.to_bit_string (Ipaddr.V4.of_string_exn "192.168.0.1"))

let test_to_bit_string2 () =
  Alcotest.(check string) "bit conversion" "00000000000000000000000000000000"
    (Ipaddr_ext.V4.to_bit_string (Ipaddr.V4.of_string_exn "0.0.0.0"))

let test_to_bit_string3 () =
  Alcotest.(check string) "bit conversion" "11111111111111111111111111111111"
    (Ipaddr_ext.V4.to_bit_string (Ipaddr.V4.of_string_exn "255.255.255.255"))

let test_to_bit_string_v6 () =
  Alcotest.(check string) "bit conversion" "00100000000000010000110110111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
    (Ipaddr_ext.V6.to_bit_string (Ipaddr.V6.of_string_exn "2001:db8::1"))

let test_to_bit_string_v6_2 () =
  Alcotest.(check string) "bit conversion" "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    (Ipaddr_ext.V6.to_bit_string (Ipaddr.V6.of_string_exn "::"))

let test_to_bit_string_v6_3 () =
  Alcotest.(check string) "bit conversion" "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
    (Ipaddr_ext.V6.to_bit_string (Ipaddr.V6.of_string_exn "::1"))

let test_subnet_to_seq () =
  let prefix = Ipaddr.V4.Prefix.of_string_exn "192.168.0.0/24" in
  (* let sn1 = Ipaddr.V4.Prefix.of_string_exn "192.168.0.0/25" in *)
  (* let sn2 = Ipaddr.V4.Prefix.of_string_exn "192.168.0.128/25" in *)
  (* Alcotest.(check int) "generate subnets" [sn1; sn2] *)
  (* (Ipaddr_ext.V4.Prefix.subnets_to_seq 25 prefix |> List.of_seq) *)
  Alcotest.(check int) "generate subnets" 2
  (Ipaddr_ext.V4.Prefix.subnets_to_seq 25 prefix |> List.of_seq |> List.length)

let () =
  let open Alcotest in
  run "ipaddr_ext" [
    "ipv4-tests", [
      test_case "String of bits" `Quick test_to_bit_string;
      test_case "String of bits" `Quick test_to_bit_string2;
      test_case "String of bits" `Quick test_to_bit_string3;
      test_case "Subnet to seq" `Quick test_subnet_to_seq;
    ];
    "ipv6-tests", [
      test_case "String of bits" `Quick test_to_bit_string_v6;
      test_case "String of bits" `Quick test_to_bit_string_v6_2;
      test_case "String of bits" `Quick test_to_bit_string_v6_3;
    ]
  ]

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
