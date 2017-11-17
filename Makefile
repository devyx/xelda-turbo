xelda-turbo.tzx: asm/real/part1.obj asm/real/part2.obj asm/real/screen.obj asm/real/loader.obj
	pasmo --tzx -I asm/real asm/stage2.asm stage2.tzx
	pasmo --tzx -I asm/real asm/screen.asm screen.tzx
	pasmo --tzx -I asm/real asm/part1.asm part1.tzx
	pasmo --tzx -I asm/real asm/part2.asm part2.tzx
	python ./utils/tzx_turbo.py screen.tzx screen-t.tzx
	python ./utils/tzx_turbo.py part1.tzx part1-t.tzx
	python ./utils/tzx_turbo.py part2.tzx part2-t.tzx
	cat stage1.tzx stage2.tzx screen-t.tzx part1-t.tzx delay.tzx part2-t.tzx > xelda-turbo.tzx


asm/real/part1.obj: asm/part1.asm  src/ram6-32768-15267.exo src/ram3-32768-16332.exo src/ram7-32768-14181.exo
	pasmo --bin -I asm/dummy/ asm/part1.asm asm/part1.bin part1.obj.tmp
	grep part1_end part1.obj.tmp >asm/real/part1.obj

asm/real/part2.obj: asm/part2.asm asm/deexo.asm src/ram4-32768-16306.exo src/ram1-32768-14512.exo src/main-24200-36115.exo
	pasmo --bin -I asm/dummy/ asm/part2.asm asm/part2.bin part2.obj.tmp
	grep part2_end part2.obj.tmp >asm/real/part2.obj

src/ram4-32768-16306.exo: src/ram4-32768-16306.bin
src/ram1-32768-14512.exo: src/ram1-32768-14512.bin
src/main-24200-36115.exo: src/main-24200-36115.bin
src/ram6-32768-15267.exo: src/ram6-32768-15267.bin
src/ram3-32768-16332.exo: src/ram3-32768-16332.bin
src/ram7-32768-14181.exo: src/ram7-32768-14181.bin

src/%.exo: src/%.bin
	wine utils/exomizer.exe raw -c -o `echo $< |sed s/bin/tmp/` `echo $<`
	wine utils/exoopt.exe `echo $< |sed s/bin/tmp/` `echo $< |sed s/bin/exo/`
	rm `echo $< |sed s/bin/tmp/`



asm/real/screen.obj: asm/screen.asm src/screen.exo
	pasmo --bin -I asm/dummy/ asm/screen.asm asm/screen.bin screen.obj.tmp
	grep screen_end screen.obj.tmp >asm/real/screen.obj
	rm screen.obj.tmp asm/screen.bin

src/screen.exo: src/screen.bin
	python ./utils/rcs.py src/screen.bin screen.rcs
	wine ./utils/exomizer.exe raw -c -o screen.exo screen.rcs
	wine ./utils/exoopt.exe screen.exo src/screen.exo
	rm screen.exo screen.rcs

asm/real/loader.obj: asm/stage2.asm asm/deexo.asm tape/tapeload.bin
	pasmo --bin -I asm/dummy/ asm/stage2.asm asm/stage2.bin stage2.obj.tmp
	grep -E "(deexo|switchbank)" stage2.obj.tmp >asm/real/loader.obj
	rm stage2.obj.tmp asm/stage2.bin

stage1.tzx: asm/stage1.bas
	./utils/bas2tap/bas2tap -a10 -s"XELDA 1.03" asm/stage1.bas asm/stage1.tap
	tapeconv asm/stage1.tap stage1.tzx

tape/tapeload.bin: tape/SL_2-5_1-6.asm
	pasmo --bin tape/SL_2-5_1-6.asm tape/tapeload.bin tape/tapeload.org

