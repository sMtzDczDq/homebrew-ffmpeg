#!/usr/bin/env bash
set -x

AWK="$(shell brew --prefix gawk)/libexec/gnubin/awk"
GREP="$(shell brew --prefix grep)/libexec/gnubin/grep"
NPROC="$(shell brew --prefix coreutils)/libexec/gnubin/nproc"
SED="$(shell brew --prefix gnu-sed)/libexec/gnubin/sed"
SORT="$(shell brew --prefix coreutils)/libexec/gnubin/sort"
TEE="$(shell brew --prefix coreutils)/libexec/gnubin/tee"
UNIQ="$(shell brew --prefix coreutils)/libexec/gnubin/uniq"
XARGS="$(shell brew --prefix findutils)/libexec/gnubin/xargs"

ffmpeg -hide_banner -buildconf | "$GREP" --color=never "^    --" | "$AWK" '{print $$1}' | "$UNIQ" | "$TEE" docs/buildconf.txt
ffmpeg -hide_banner -muxers | "$GREP" --color=never "^  E " | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$TEE" docs/muxers.txt
ffmpeg -hide_banner -demuxers | "$GREP" --color=never "^ D " | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$TEE" docs/demuxers.txt
ffmpeg -hide_banner -codecs | "$GREP" --color=never "^ D" | "$GREP" --color=never -v "=" | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/codecs-decode.txt
ffmpeg -hide_banner -codecs | "$GREP" --color=never "^ .E" | "$GREP" --color=never -v "=" | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/codecs-encode.txt
ffmpeg -hide_banner -decoders | "$GREP" --color=never -E "^ (V|A|S)" | "$GREP" --color=never -v "=" | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/decoders.txt
ffmpeg -hide_banner -encoders | "$GREP" --color=never -E "^ (V|A|S)" | "$GREP" --color=never -v "=" | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/encoders.txt
ffmpeg -hide_banner -bsfs | "$GREP" --color=never -v "Bitstream filters:" | "$AWK" '{print $$1}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/bsfs.txt
ffmpeg -hide_banner -pix_fmts | "$GREP" --color=never -E "^(I|\.)" | "$GREP" --color=never -v "=" | "$AWK" '{print $$2}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/pix_fmts.txt
ffmpeg -hide_banner -hwaccels| "$GREP" --color=never -v "Hardware acceleration methods:" | "$AWK" '{print $$1}' | "$XARGS" -I% bash -c 'echo "\`%\`"' _ % | "$UNIQ" | "$SORT" | "$TEE" docs/hwaccels.txt
