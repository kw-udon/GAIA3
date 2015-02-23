library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.types.all;

entity bram is

  port (
    clk      : in  std_logic;
    bram_in  : in  bram_in_type;
    bram_out : out bram_out_type);

end entity;

architecture behavioral of bram is

  type ram_t is
    array(0 to 8191) of std_logic_vector(31 downto 0);

--pragma synthesis_off

  constant myram : ram_t := (
    0 => (others => '0'),
    1 => "0010" & "00001" & "00000" & "00" & x"FEDB",
    2 => (others => '0'),
    3 => (others => '0'),
    4 => (others => '0'),
    5 => (others => '0'),
    6 => (others => '0'),
    7 => (others => '0'),
    8 => "0011" & "00001" & "00001" & "00" & x"CA98",
    others => (others => '0'));

  constant myram2 : ram_t := (
    (others => '0'),
    "0010" & "00001" & "00000" & "00" & x"000A", -- 1
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    "1111" & "00001" & "00000" & "00" & x"0014", -- 8
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    "0000" & "00001" & "00001" & "00000" & x"01" & "00001", -- 15
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    "1011" & "11111" & "00000" & "00" & x"FFF1", -- 22
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    "1011" & "11111" & "00000" & "00" & x"FFFF", -- 29
    others => (others => '0'));

  constant myram3 : ram_t := (
    (others => '0'),
    "0000" & "00001" & "00000" & "00000" & x"01" & "00000",
    "0000" & "00010" & "00000" & "00000" & x"02" & "00000",
    "0000" & "00011" & "00000" & "00000" & x"03" & "00000",
    "0000" & "00100" & "00000" & "00000" & x"04" & "00000",
    "0000" & "00101" & "00000" & "00000" & x"05" & "00000",
    "0000" & "00110" & "00000" & "00000" & x"06" & "00000",
    "0000" & "00001" & "00001" & "00010" & x"00" & "00000",
    "0000" & "00001" & "00001" & "00011" & x"00" & "00000",
    "0000" & "00001" & "00001" & "00100" & x"00" & "00000",
    "0000" & "00001" & "00001" & "00101" & x"00" & "00000",
    "0000" & "00001" & "00001" & "00110" & x"00" & "00000",
    others => (others => '0'));

  -- mov r1, 1
  -- mov r2, 2
  -- st r1, r0, 108
  -- st r2, r0, 112
  -- ld r3, r0, 108
  -- ld r4, r0, 112
  -- add r5, r3, r4

  constant myram4 : ram_t := (
    (others => '0'),

    "0000" & "00001" & "00000" & "00000" & x"01" & "00000",
    "0000" & "00010" & "00000" & "00000" & x"02" & "00000",

    "0110" & "00001" & "00000" & "00" & x"006C",
    "0110" & "00010" & "00000" & "00" & x"0070",

    "1000" & "00011" & "00000" & "00" & x"006C",
    "1000" & "00100" & "00000" & "00" & x"0070",

    "0000" & "00101" & "00011" & "00100" & x"00" & "00000",

    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0'),
    others => (others => '0'));

  -- mov r1, 0xA
  -- beq r1, r0, 8
  -- sub r1, r1, 1
  -- jl r31, -C
  -- jl r31, -4

  constant myram5 : ram_t := (
    (others => '0'),                    -- 0
    "0010" & "00001" & "00000" & "00" & x"000A", -- 4
    "1111" & "00001" & "00000" & "00" & x"0002", -- 8
    "0000" & "00001" & "00001" & "00000" & x"01" & "00001", -- C
    "1011" & "11111" & "00000" & "00" & x"FFFD",            -- 10
    "1011" & "11111" & "00000" & "00" & x"FFFF",            -- 14
    others => (others => '0'));

  -- mov r1, 10
  -- mov r2, 3
  -- bne r1, r2, [40]
  -- mov r3, 4

  constant myram6 : ram_t := (
    (others => '0'),
    "0010" & "00001" & "00000" & "00" & x"000A",
    "0010" & "00010" & "00000" & "00" & x"0003",
    "1101" & "00001" & "00010" & "00" & x"0040",
    "0010" & "00011" & "00000" & "00" & x"0004",
    others => (others => '0'));

  -- mov r1, 1
  -- add r2, r1, r0
  -- beq r1, r2, [40]
  -- mov r3, 3

  constant myram7 : ram_t := (
    (others => '0'),
    "0010" & "00001" & "00000" & "00" & x"0001",
    "0000" & "00010" & "00001" & "00000" & x"00" & "00000",
    "1111" & "00001" & "00010" & "00" & x"0040",
    "0010" & "00011" & "00000" & "00" & x"0003",
    others => (others => '0'));

  -- mov r1, 1
  -- cmpeq r2, r1, r0, 1

  constant myram8 : ram_t := (
    (others => '0'),
    "0010" & "00001" & "00000" & "00" & x"0001",
    "0000" & "00010" & "00001" & "00000" & x"01" & "11001",
    others => (others => '0'));

  constant myram9 : ram_t := (
x"2e80000c",
x"3ef40000",
x"ce830000",
x"00000000",
x"00000000",
x"00000000",
x"2180000a",
x"20800000",
x"21000001",
x"02040000",
x"00880000",
x"01088000",
x"018c0021",
x"d180fffb",
x"ffffffff",
others => (others => '0')
    );

  constant myram_fibrecur : ram_t := (
0 => x"2e800070",
1 => x"3ef40000",
2 => x"ce830000",
3 => x"0f780181",
4 => x"6e780000",
5 => x"0e84005a",
6 => x"de800014",
7 => x"60fcffff",
8 => x"00840021",
9 => x"6ff8ffff",
10 => x"0f780081",
11 => x"0ff80000",
12 => x"be03fff6",
13 => x"0f7c0080",
14 => x"8ff8ffff",
15 => x"60fcfffe",
16 => x"80fcffff",
17 => x"00840041",
18 => x"6ff8ffff",
19 => x"0f780081",
20 => x"0ff80000",
21 => x"be03ffed",
22 => x"0f7c0080",
23 => x"8ff8ffff",
24 => x"817cfffe",
25 => x"00844000",
26 => x"8e780000",
27 => x"ce030000",
28 => x"3f000040",
29 => x"3f800040",
30 => x"2080000a",
31 => x"6ff8ffff",
32 => x"0f780081",
33 => x"0ff80000",
34 => x"be03ffe0",
35 => x"0f7c0080",
36 => x"8ff8ffff",
37 => x"ffffffff",
others => (others => '0'));

  constant myram_loopback : ram_t := (
0 => x"2e80000c",
1 => x"3ef40000",
2 => x"ce830000",
3 => x"80800800",
4 => x"2100ffff",
5 => x"f088fffd",
6 => x"60800800",
7 => x"be83fffb",
others => (others => '0'));

  constant myram_ramtest : ram_t := (
0 => x"2e8000aa",
1 => x"6e801000",
2 => x"80801000",
3 => x"2e8000bb",
4 => x"6e801001",
5 => x"81001000",
6 => x"81801001",
7 => x"ffffffff",
others => (others => '0')
);

  constant myram_fib1 : ram_t := (
0 => x"2e800010",
1 => x"3ef40000",
2 => x"ce830000",
3 => x"ce030000",
4 => x"3f000040",
5 => x"3f800040",
6 => x"2080000a",
7 => x"6ff8ffff",
8 => x"0f780081",
9 => x"0ff80000",
10 => x"be03fff8",
11 => x"0f7c0080",
12 => x"8ff8ffff",
13 => x"ffffffff",
others => (others => '0')
    );

  constant myram_ramtest2 : ram_t := (
0 => x"2e8000aa",
1 => x"6e801000",
2 => x"80801000",
3 => x"00840020",
4 => x"ffffffff",
others => (others => '0')
);

  -- test cache (all hit)

  constant udon_ram_test : ram_t := (
0 => x"2e80000c",
1 => x"3ef40000",
2 => x"ce830000",
3 => x"3f000040",
4 => x"3f800040",
5 => x"20800000",
6 => x"21000000",
7 => x"0184021a",
8 => x"f180000f",
9 => x"21000000",
10 => x"0188021a",
11 => x"f180000a",
12 => x"2e800400",
13 => x"027fa001",
14 => x"018400c2",
15 => x"018c8000",
16 => x"02080042",
17 => x"018c8000",
18 => x"02044000",
19 => x"620c0000",
20 => x"01080020",
21 => x"be83fff4",
22 => x"00840020",
23 => x"be83ffef",
24 => x"20800000",
25 => x"21000000",
26 => x"0184021a",
27 => x"f180000f",
28 => x"21000000",
29 => x"0188021a",
30 => x"f1800009",
31 => x"2e800400",
32 => x"027fa001",
33 => x"018400c2",
34 => x"018c8000",
35 => x"02080042",
36 => x"018c8000",
37 => x"830c0000",
38 => x"01080020",
39 => x"be83fff5",
40 => x"2300ffff",
41 => x"00840020",
42 => x"be83ffef",
43 => x"ffffffff",
others => (others => '0')
);

  constant ramtest : ram_t := (
0 => x"2e80000c",
1 => x"3ef40000",
2 => x"ce830000",
3 => x"3f000040",
4 => x"3f800040",
5 => x"20800000",
6 => x"21000000",
7 => x"0188021a",
8 => x"f180000f",
9 => x"20800000",
10 => x"0184021a",
11 => x"f180000a",
12 => x"2e800400",
13 => x"027fa001",
14 => x"018400c2",
15 => x"018c8000",
16 => x"02080042",
17 => x"018c8000",
18 => x"02044000",
19 => x"620c0000",
20 => x"00840020",
21 => x"be83fff4",
22 => x"01080020",
23 => x"be83ffef",
24 => x"20800000",
25 => x"21000000",
26 => x"0188021a",
27 => x"f1800012",
28 => x"20800000",
29 => x"0184021a",
30 => x"f180000c",
31 => x"2e800400",
32 => x"027fa001",
33 => x"018400c2",
34 => x"018c8000",
35 => x"02080042",
36 => x"018c8000",
37 => x"830c0000",
38 => x"2e804000",
39 => x"018fa001",
40 => x"848c0000",
41 => x"00840020",
42 => x"be83fff2",
43 => x"2300ffff",
44 => x"01080020",
45 => x"be83ffec",
46 => x"ffffffff",
others => (others => '0')
);

  constant bootloader : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"80800800",
5 => x"0e84001a",
6 => x"de80fffd",
7 => x"81000800",
8 => x"0e88001a",
9 => x"de80fffd",
10 => x"81800800",
11 => x"0e8c001a",
12 => x"de80fffd",
13 => x"82000800",
14 => x"0e90001a",
15 => x"de80fffd",
16 => x"00840302",
17 => x"01080202",
18 => x"018c0102",
19 => x"00844000",
20 => x"018c8000",
21 => x"00846000",
22 => x"21000000",
23 => x"21803000",
24 => x"318c0000",
25 => x"f0880016",
26 => x"82800800",
27 => x"0e94001a",
28 => x"de80fffd",
29 => x"83000800",
30 => x"0e98001a",
31 => x"de80fffd",
32 => x"83800800",
33 => x"0e9c001a",
34 => x"de80fffd",
35 => x"84000800",
36 => x"0ea0001a",
37 => x"de80fffd",
38 => x"02940302",
39 => x"03180202",
40 => x"039c0102",
41 => x"0294c000",
42 => x"039d0000",
43 => x"0294e000",
44 => x"02086000",
45 => x"62900000",
46 => x"01080080",
47 => x"d08bffea",
48 => x"c1830000",
others => (others => '0')
);

  constant myram_bootloader_msg : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"2e80000d",
5 => x"6e800800",
6 => x"2e80000a",
7 => x"6e800800",
8 => x"2e800047",
9 => x"6e800800",
10 => x"2e800041",
11 => x"6e800800",
12 => x"2e800049",
13 => x"6e800800",
14 => x"2e800041",
15 => x"6e800800",
16 => x"2e800020",
17 => x"6e800800",
18 => x"2e800041",
19 => x"6e800800",
20 => x"2e800072",
21 => x"6e800800",
22 => x"2e800063",
23 => x"6e800800",
24 => x"2e800068",
25 => x"6e800800",
26 => x"2e800069",
27 => x"6e800800",
28 => x"2e800074",
29 => x"6e800800",
30 => x"2e800065",
31 => x"6e800800",
32 => x"2e800063",
33 => x"6e800800",
34 => x"2e800074",
35 => x"6e800800",
36 => x"2e800075",
37 => x"6e800800",
38 => x"2e800072",
39 => x"6e800800",
40 => x"2e800065",
41 => x"6e800800",
42 => x"2e80000d",
43 => x"6e800800",
44 => x"2e80000a",
45 => x"6e800800",
46 => x"2e80000d",
47 => x"6e800800",
48 => x"2e80000a",
49 => x"6e800800",
50 => x"2e800057",
51 => x"6e800800",
52 => x"2e800061",
53 => x"6e800800",
54 => x"2e800069",
55 => x"6e800800",
56 => x"2e800074",
57 => x"6e800800",
58 => x"2e800069",
59 => x"6e800800",
60 => x"2e80006e",
61 => x"6e800800",
62 => x"2e800067",
63 => x"6e800800",
64 => x"2e800020",
65 => x"6e800800",
66 => x"2e800066",
67 => x"6e800800",
68 => x"2e80006f",
69 => x"6e800800",
70 => x"2e800072",
71 => x"6e800800",
72 => x"2e800020",
73 => x"6e800800",
74 => x"2e800069",
75 => x"6e800800",
76 => x"2e80006e",
77 => x"6e800800",
78 => x"2e800070",
79 => x"6e800800",
80 => x"2e800075",
81 => x"6e800800",
82 => x"2e800074",
83 => x"6e800800",
84 => x"2e80002e",
85 => x"6e800800",
86 => x"2e80002e",
87 => x"6e800800",
88 => x"2e80002e",
89 => x"6e800800",
90 => x"2e80000d",
91 => x"6e800800",
92 => x"2e80000a",
93 => x"6e800800",
94 => x"80800800",
95 => x"0e84001a",
96 => x"de80fffd",
97 => x"81000800",
98 => x"0e88001a",
99 => x"de80fffd",
100 => x"81800800",
101 => x"0e8c001a",
102 => x"de80fffd",
103 => x"82000800",
104 => x"0e90001a",
105 => x"de80fffd",
106 => x"00840302",
107 => x"01080202",
108 => x"018c0102",
109 => x"00844000",
110 => x"018c8000",
111 => x"00846000",
112 => x"21000000",
113 => x"21803000",
114 => x"318c0000",
115 => x"f088001f",
116 => x"2e8003ff",
117 => x"048bbfe5",
118 => x"d4800006",
119 => x"6ff8ffff",
120 => x"0f780081",
121 => x"0ff80000",
122 => x"be030063",
123 => x"0f7c0080",
124 => x"8ff8ffff",
125 => x"82800800",
126 => x"0e94001a",
127 => x"de80fffd",
128 => x"83000800",
129 => x"0e98001a",
130 => x"de80fffd",
131 => x"83800800",
132 => x"0e9c001a",
133 => x"de80fffd",
134 => x"84000800",
135 => x"0ea0001a",
136 => x"de80fffd",
137 => x"02940302",
138 => x"03180202",
139 => x"039c0102",
140 => x"0294c000",
141 => x"039d0000",
142 => x"0294e000",
143 => x"02086000",
144 => x"62900000",
145 => x"01080080",
146 => x"d08bffe1",
147 => x"2e80000d",
148 => x"6e800800",
149 => x"2e80004c",
150 => x"6e800800",
151 => x"2e80006f",
152 => x"6e800800",
153 => x"2e800061",
154 => x"6e800800",
155 => x"2e800064",
156 => x"6e800800",
157 => x"2e800069",
158 => x"6e800800",
159 => x"2e80006e",
160 => x"6e800800",
161 => x"2e800067",
162 => x"6e800800",
163 => x"2e800020",
164 => x"6e800800",
165 => x"2e800063",
166 => x"6e800800",
167 => x"2e80006f",
168 => x"6e800800",
169 => x"2e80006d",
170 => x"6e800800",
171 => x"2e800070",
172 => x"6e800800",
173 => x"2e80006c",
174 => x"6e800800",
175 => x"2e800065",
176 => x"6e800800",
177 => x"2e800074",
178 => x"6e800800",
179 => x"2e800065",
180 => x"6e800800",
181 => x"2e800064",
182 => x"6e800800",
183 => x"2e800021",
184 => x"6e800800",
185 => x"2e800020",
186 => x"6e800800",
187 => x"2e800020",
188 => x"6e800800",
189 => x"2e800020",
190 => x"6e800800",
191 => x"2e800020",
192 => x"6e800800",
193 => x"2e800020",
194 => x"6e800800",
195 => x"2e800020",
196 => x"6e800800",
197 => x"2e800020",
198 => x"6e800800",
199 => x"2e800020",
200 => x"6e800800",
201 => x"2e800020",
202 => x"6e800800",
203 => x"2e800020",
204 => x"6e800800",
205 => x"2e800020",
206 => x"6e800800",
207 => x"2e800020",
208 => x"6e800800",
209 => x"2e800020",
210 => x"6e800800",
211 => x"2e800020",
212 => x"6e800800",
213 => x"2e80000d",
214 => x"6e800800",
215 => x"2e80000a",
216 => x"6e800800",
217 => x"2e80000d",
218 => x"6e800800",
219 => x"2e80000a",
220 => x"6e800800",
221 => x"c1830000",
222 => x"0f780081",
223 => x"6e780000",
224 => x"2e80000d",
225 => x"6e800800",
226 => x"2e80004c",
227 => x"6e800800",
228 => x"2e80006f",
229 => x"6e800800",
230 => x"2e800061",
231 => x"6e800800",
232 => x"2e800064",
233 => x"6e800800",
234 => x"2e800069",
235 => x"6e800800",
236 => x"2e80006e",
237 => x"6e800800",
238 => x"2e800067",
239 => x"6e800800",
240 => x"2e80002e",
241 => x"6e800800",
242 => x"2e80002e",
243 => x"6e800800",
244 => x"2e80002e",
245 => x"6e800800",
246 => x"2e800020",
247 => x"6e800800",
248 => x"2e80005b",
249 => x"6e800800",
250 => x"05880143",
251 => x"6ff8ffff",
252 => x"0f780081",
253 => x"0ff80000",
254 => x"be030021",
255 => x"0f7c0080",
256 => x"8ff8ffff",
257 => x"2e800020",
258 => x"6e800800",
259 => x"2e80006b",
260 => x"6e800800",
261 => x"2e800042",
262 => x"6e800800",
263 => x"2e800020",
264 => x"6e800800",
265 => x"2e80002f",
266 => x"6e800800",
267 => x"2e800020",
268 => x"6e800800",
269 => x"2e8003ff",
270 => x"0587a000",
271 => x"05ac0143",
272 => x"6ff8ffff",
273 => x"0f780081",
274 => x"0ff80000",
275 => x"be03000c",
276 => x"0f7c0080",
277 => x"8ff8ffff",
278 => x"2e800020",
279 => x"6e800800",
280 => x"2e80006b",
281 => x"6e800800",
282 => x"2e800042",
283 => x"6e800800",
284 => x"2e80005d",
285 => x"6e800800",
286 => x"8e780000",
287 => x"ce030000",
288 => x"0f780081",
289 => x"6e780000",
290 => x"0eac015a",
291 => x"de80001c",
292 => x"0eac0c9a",
293 => x"de800013",
294 => x"2e8003e8",
295 => x"0eafa01a",
296 => x"de800009",
297 => x"260003e8",
298 => x"6ff8ffff",
299 => x"0f780081",
300 => x"0ff80000",
301 => x"be03001b",
302 => x"0f7c0080",
303 => x"8ff8ffff",
304 => x"2e80002c",
305 => x"6e800800",
306 => x"26000064",
307 => x"6ff8ffff",
308 => x"0f780081",
309 => x"0ff80000",
310 => x"be030012",
311 => x"0f7c0080",
312 => x"8ff8ffff",
313 => x"2600000a",
314 => x"6ff8ffff",
315 => x"0f780081",
316 => x"0ff80000",
317 => x"be03000b",
318 => x"0f7c0080",
319 => x"8ff8ffff",
320 => x"26000001",
321 => x"6ff8ffff",
322 => x"0f780081",
323 => x"0ff80000",
324 => x"be030004",
325 => x"0f7c0080",
326 => x"8ff8ffff",
327 => x"8e780000",
328 => x"ce030000",
329 => x"26800030",
330 => x"be830002",
331 => x"05ad8001",
332 => x"06b40020",
333 => x"0ead801a",
334 => x"fe80fffc",
335 => x"66800800",
336 => x"ce030000",
others => (others => '0')
);

  constant myram_bootloader_dbg : ram_t := (
0 => x"20800062",
1 => x"2100006f",
2 => x"21800074",
3 => x"22000069",
4 => x"2280006e",
5 => x"23000067",
6 => x"2380002e",
7 => x"2400000d",
8 => x"2480000a",
9 => x"60800800",
10 => x"61000800",
11 => x"61000800",
12 => x"61800800",
13 => x"62000800",
14 => x"62800800",
15 => x"63000800",
16 => x"63800800",
17 => x"63800800",
18 => x"63800800",
19 => x"64000800",
20 => x"64800800",
21 => x"80800800",
22 => x"0e84001a",
23 => x"de80fffd",
24 => x"81000800",
25 => x"0e88001a",
26 => x"de80fffd",
27 => x"81800800",
28 => x"0e8c001a",
29 => x"de80fffd",
30 => x"82000800",
31 => x"0e90001a",
32 => x"de80fffd",
33 => x"00840302",
34 => x"01080202",
35 => x"018c0102",
36 => x"00844000",
37 => x"018c8000",
38 => x"00846000",
39 => x"21000000",
40 => x"21803000",
41 => x"318c0000",
42 => x"f088001c",
43 => x"2e800041",
44 => x"6e800800",
45 => x"82800800",
46 => x"0e94001a",
47 => x"de80fffd",
48 => x"83000800",
49 => x"0e98001a",
50 => x"de80fffd",
51 => x"83800800",
52 => x"0e9c001a",
53 => x"de80fffd",
54 => x"84000800",
55 => x"0ea0001a",
56 => x"de80fffd",
57 => x"2e800042",
58 => x"6e800800",
59 => x"02940302",
60 => x"03180202",
61 => x"039c0102",
62 => x"0294c000",
63 => x"039d0000",
64 => x"0294e000",
65 => x"02086000",
66 => x"2e800043",
67 => x"6e800800",
68 => x"62900000",
69 => x"01080080",
70 => x"d08bffe4",
71 => x"2080006c",
72 => x"2100006f",
73 => x"24800061",
74 => x"22000064",
75 => x"22800065",
76 => x"23000021",
77 => x"2380000d",
78 => x"2400000a",
79 => x"60800800",
80 => x"61000800",
81 => x"64800800",
82 => x"62000800",
83 => x"62800800",
84 => x"62000800",
85 => x"63000800",
86 => x"63800800",
87 => x"64000800",
88 => x"2f000000",
89 => x"3f780040",
90 => x"2f800000",
91 => x"3ffc0040",
92 => x"c1830000",
others => (others => '0')
);

  constant foo : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"6ff8ffff",
5 => x"0f780081",
6 => x"0ff80000",
7 => x"be030002",
8 => x"0f7c0080",
9 => x"8ff8ffff",
10 => x"0f780081",
11 => x"6e780000",
12 => x"6ff8ffff",
13 => x"0f780081",
14 => x"0ff80000",
15 => x"be030004",
16 => x"0f7c0080",
17 => x"8ff8ffff",
18 => x"8e780000",
19 => x"ce030000",
20 => x"0f780081",
21 => x"6e780000",
22 => x"0eac015a",
23 => x"de80001c",
24 => x"0eac0c9a",
25 => x"de800013",
26 => x"2e8003e8",
27 => x"0eafa01a",
28 => x"de800009",
29 => x"260003e8",
30 => x"6ff8ffff",
31 => x"0f780081",
32 => x"0ff80000",
33 => x"be03001b",
34 => x"0f7c0080",
35 => x"8ff8ffff",
36 => x"2e80002c",
37 => x"6e800800",
38 => x"26000064",
39 => x"6ff8ffff",
40 => x"0f780081",
41 => x"0ff80000",
42 => x"be030012",
43 => x"0f7c0080",
44 => x"8ff8ffff",
45 => x"2600000a",
46 => x"6ff8ffff",
47 => x"0f780081",
48 => x"0ff80000",
49 => x"be03000b",
50 => x"0f7c0080",
51 => x"8ff8ffff",
52 => x"26000001",
53 => x"6ff8ffff",
54 => x"0f780081",
55 => x"0ff80000",
56 => x"be030004",
57 => x"0f7c0080",
58 => x"8ff8ffff",
59 => x"8e780000",
60 => x"ce030000",
61 => x"26800030",
62 => x"be830002",
63 => x"05ad8001",
64 => x"06b40020",
65 => x"0ead801a",
66 => x"fe80fffc",
67 => x"66800800",
68 => x"ce030000",
others => (others => '0')
);

  constant bar : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"6ff8ffff",
5 => x"0f780081",
6 => x"0ff80000",
7 => x"be030002",
8 => x"0f7c0080",
9 => x"8ff8ffff",
10 => x"0f780081",
11 => x"6e780000",
12 => x"6ff8ffff",
13 => x"0f780081",
14 => x"0ff80000",
15 => x"be030004",
16 => x"0f7c0080",
17 => x"8ff8ffff",
18 => x"8e780000",
19 => x"ce030000",
20 => x"0f780081",
21 => x"6e780000",
22 => x"26000001",
23 => x"6ff8ffff",
24 => x"0f780081",
25 => x"0ff80000",
26 => x"be030004",
27 => x"0f7c0080",
28 => x"8ff8ffff",
29 => x"8e780000",
30 => x"ce030000",
31 => x"26800030",
32 => x"be830002",
33 => x"05ad8001",
34 => x"06b40020",
35 => x"0ead801a",
36 => x"fe80fffc",
37 => x"66800800",
38 => x"ce030000",
others => (others => '0')
);

  constant baz : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"6ff8ffff",
5 => x"0f780081",
6 => x"0ff80000",
7 => x"be030003",
8 => x"0f7c0080",
9 => x"8ff8ffff",
10 => x"ffffffff",
11 => x"0f780081",
12 => x"6e780000",
13 => x"6ff8ffff",
14 => x"0f780081",
15 => x"0ff80000",
16 => x"be030005",
17 => x"0f7c0080",
18 => x"8ff8ffff",
19 => x"8e780000",
20 => x"0f780080",
21 => x"ce030000",
22 => x"ce030000",
others => (others => '0')
);

--pragma synthesis_on

  constant bootloader_prog : ram_t := (
0 => x"2f000000",
1 => x"3f780040",
2 => x"2f800000",
3 => x"3ffc0040",
4 => x"2e80000d",
5 => x"6e800800",
6 => x"2e80000a",
7 => x"6e800800",
8 => x"2e800047",
9 => x"6e800800",
10 => x"2e800041",
11 => x"6e800800",
12 => x"2e800049",
13 => x"6e800800",
14 => x"2e800041",
15 => x"6e800800",
16 => x"2e800020",
17 => x"6e800800",
18 => x"2e800041",
19 => x"6e800800",
20 => x"2e800072",
21 => x"6e800800",
22 => x"2e800063",
23 => x"6e800800",
24 => x"2e800068",
25 => x"6e800800",
26 => x"2e800069",
27 => x"6e800800",
28 => x"2e800074",
29 => x"6e800800",
30 => x"2e800065",
31 => x"6e800800",
32 => x"2e800063",
33 => x"6e800800",
34 => x"2e800074",
35 => x"6e800800",
36 => x"2e800075",
37 => x"6e800800",
38 => x"2e800072",
39 => x"6e800800",
40 => x"2e800065",
41 => x"6e800800",
42 => x"2e80000d",
43 => x"6e800800",
44 => x"2e80000a",
45 => x"6e800800",
46 => x"2e80000d",
47 => x"6e800800",
48 => x"2e80000a",
49 => x"6e800800",
50 => x"2e800057",
51 => x"6e800800",
52 => x"2e800061",
53 => x"6e800800",
54 => x"2e800069",
55 => x"6e800800",
56 => x"2e800074",
57 => x"6e800800",
58 => x"2e800069",
59 => x"6e800800",
60 => x"2e80006e",
61 => x"6e800800",
62 => x"2e800067",
63 => x"6e800800",
64 => x"2e800020",
65 => x"6e800800",
66 => x"2e800066",
67 => x"6e800800",
68 => x"2e80006f",
69 => x"6e800800",
70 => x"2e800072",
71 => x"6e800800",
72 => x"2e800020",
73 => x"6e800800",
74 => x"2e800069",
75 => x"6e800800",
76 => x"2e80006e",
77 => x"6e800800",
78 => x"2e800070",
79 => x"6e800800",
80 => x"2e800075",
81 => x"6e800800",
82 => x"2e800074",
83 => x"6e800800",
84 => x"2e80002e",
85 => x"6e800800",
86 => x"2e80002e",
87 => x"6e800800",
88 => x"2e80002e",
89 => x"6e800800",
90 => x"2e80000d",
91 => x"6e800800",
92 => x"2e80000a",
93 => x"6e800800",
94 => x"80800800",
95 => x"0e84001a",
96 => x"de80fffd",
97 => x"81000800",
98 => x"0e88001a",
99 => x"de80fffd",
100 => x"81800800",
101 => x"0e8c001a",
102 => x"de80fffd",
103 => x"82000800",
104 => x"0e90001a",
105 => x"de80fffd",
106 => x"00840302",
107 => x"01080202",
108 => x"018c0102",
109 => x"00844000",
110 => x"018c8000",
111 => x"00846000",
112 => x"21000000",
113 => x"21803000",
114 => x"318c0000",
115 => x"f088001f",
116 => x"2e8003ff",
117 => x"048bbfe5",
118 => x"d4800006",
119 => x"6ff8ffff",
120 => x"0f780081",
121 => x"0ff80000",
122 => x"be030063",
123 => x"0f7c0080",
124 => x"8ff8ffff",
125 => x"82800800",
126 => x"0e94001a",
127 => x"de80fffd",
128 => x"83000800",
129 => x"0e98001a",
130 => x"de80fffd",
131 => x"83800800",
132 => x"0e9c001a",
133 => x"de80fffd",
134 => x"84000800",
135 => x"0ea0001a",
136 => x"de80fffd",
137 => x"02940302",
138 => x"03180202",
139 => x"039c0102",
140 => x"0294c000",
141 => x"039d0000",
142 => x"0294e000",
143 => x"02086000",
144 => x"62900000",
145 => x"01080080",
146 => x"d08bffe1",
147 => x"2e80000d",
148 => x"6e800800",
149 => x"2e80004c",
150 => x"6e800800",
151 => x"2e80006f",
152 => x"6e800800",
153 => x"2e800061",
154 => x"6e800800",
155 => x"2e800064",
156 => x"6e800800",
157 => x"2e800069",
158 => x"6e800800",
159 => x"2e80006e",
160 => x"6e800800",
161 => x"2e800067",
162 => x"6e800800",
163 => x"2e800020",
164 => x"6e800800",
165 => x"2e800063",
166 => x"6e800800",
167 => x"2e80006f",
168 => x"6e800800",
169 => x"2e80006d",
170 => x"6e800800",
171 => x"2e800070",
172 => x"6e800800",
173 => x"2e80006c",
174 => x"6e800800",
175 => x"2e800065",
176 => x"6e800800",
177 => x"2e800074",
178 => x"6e800800",
179 => x"2e800065",
180 => x"6e800800",
181 => x"2e800064",
182 => x"6e800800",
183 => x"2e800021",
184 => x"6e800800",
185 => x"2e800020",
186 => x"6e800800",
187 => x"2e800020",
188 => x"6e800800",
189 => x"2e800020",
190 => x"6e800800",
191 => x"2e800020",
192 => x"6e800800",
193 => x"2e800020",
194 => x"6e800800",
195 => x"2e800020",
196 => x"6e800800",
197 => x"2e800020",
198 => x"6e800800",
199 => x"2e800020",
200 => x"6e800800",
201 => x"2e800020",
202 => x"6e800800",
203 => x"2e800020",
204 => x"6e800800",
205 => x"2e800020",
206 => x"6e800800",
207 => x"2e800020",
208 => x"6e800800",
209 => x"2e800020",
210 => x"6e800800",
211 => x"2e800020",
212 => x"6e800800",
213 => x"2e80000d",
214 => x"6e800800",
215 => x"2e80000a",
216 => x"6e800800",
217 => x"2e80000d",
218 => x"6e800800",
219 => x"2e80000a",
220 => x"6e800800",
221 => x"c1830000",
222 => x"0f780081",
223 => x"6e780000",
224 => x"2e80000d",
225 => x"6e800800",
226 => x"2e80004c",
227 => x"6e800800",
228 => x"2e80006f",
229 => x"6e800800",
230 => x"2e800061",
231 => x"6e800800",
232 => x"2e800064",
233 => x"6e800800",
234 => x"2e800069",
235 => x"6e800800",
236 => x"2e80006e",
237 => x"6e800800",
238 => x"2e800067",
239 => x"6e800800",
240 => x"2e80002e",
241 => x"6e800800",
242 => x"2e80002e",
243 => x"6e800800",
244 => x"2e80002e",
245 => x"6e800800",
246 => x"2e800020",
247 => x"6e800800",
248 => x"2e80005b",
249 => x"6e800800",
250 => x"05880143",
251 => x"6ff8ffff",
252 => x"0f780081",
253 => x"0ff80000",
254 => x"be030021",
255 => x"0f7c0080",
256 => x"8ff8ffff",
257 => x"2e800020",
258 => x"6e800800",
259 => x"2e80006b",
260 => x"6e800800",
261 => x"2e800042",
262 => x"6e800800",
263 => x"2e800020",
264 => x"6e800800",
265 => x"2e80002f",
266 => x"6e800800",
267 => x"2e800020",
268 => x"6e800800",
269 => x"2e8003ff",
270 => x"0587a000",
271 => x"05ac0143",
272 => x"6ff8ffff",
273 => x"0f780081",
274 => x"0ff80000",
275 => x"be03000c",
276 => x"0f7c0080",
277 => x"8ff8ffff",
278 => x"2e800020",
279 => x"6e800800",
280 => x"2e80006b",
281 => x"6e800800",
282 => x"2e800042",
283 => x"6e800800",
284 => x"2e80005d",
285 => x"6e800800",
286 => x"8e780000",
287 => x"ce030000",
288 => x"0f780081",
289 => x"6e780000",
290 => x"0eac015a",
291 => x"de80001c",
292 => x"0eac0c9a",
293 => x"de800013",
294 => x"2e8003e8",
295 => x"0eafa01a",
296 => x"de800009",
297 => x"260003e8",
298 => x"6ff8ffff",
299 => x"0f780081",
300 => x"0ff80000",
301 => x"be03001b",
302 => x"0f7c0080",
303 => x"8ff8ffff",
304 => x"2e80002c",
305 => x"6e800800",
306 => x"26000064",
307 => x"6ff8ffff",
308 => x"0f780081",
309 => x"0ff80000",
310 => x"be030012",
311 => x"0f7c0080",
312 => x"8ff8ffff",
313 => x"2600000a",
314 => x"6ff8ffff",
315 => x"0f780081",
316 => x"0ff80000",
317 => x"be03000b",
318 => x"0f7c0080",
319 => x"8ff8ffff",
320 => x"26000001",
321 => x"6ff8ffff",
322 => x"0f780081",
323 => x"0ff80000",
324 => x"be030004",
325 => x"0f7c0080",
326 => x"8ff8ffff",
327 => x"8e780000",
328 => x"ce030000",
329 => x"26800030",
330 => x"be830002",
331 => x"05ad8001",
332 => x"06b40020",
333 => x"0ead801a",
334 => x"fe80fffc",
335 => x"66800800",
336 => x"ce030000",
others => (others => '0')
);

  signal ram : ram_t := bootloader_prog;

  signal addr_reg : std_logic_vector(31 downto 0) := (others => '0');
  signal addr_reg2 : std_logic_vector(31 downto 0) := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if bram_in.we = '1' then
        ram(conv_integer(bram_in.addr(14 downto 2))) <= bram_in.val;
      end if;
      addr_reg  <= bram_in.addr;
      addr_reg2 <= bram_in.addr2;
    end if;
  end process;

  bram_out.rx  <= ram(conv_integer(addr_reg(14 downto 2)));
  bram_out.rx2 <= ram(conv_integer(addr_reg2(14 downto 2)));

end architecture;
