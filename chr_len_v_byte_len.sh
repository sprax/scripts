#!/bin/sh
# file: chr_len_v_byte_len.sh
# expected output: Généralités has 11 chars, 14 bytes: ($'G\303\251n\303\251ralit\303\251s').
myvar='Généralités'
chrlen=${#myvar}
oLang=$LANG oLcAll=$LC_ALL
LANG=C LC_ALL=C
bytlen=${#myvar}
printf -v myreal "%q" "$myvar"
LANG=$oLang LC_ALL=$oLcAll
printf "%s has %d chars, %d bytes: (%s).\n" "${myvar}" $chrlen $bytlen "$myreal"
