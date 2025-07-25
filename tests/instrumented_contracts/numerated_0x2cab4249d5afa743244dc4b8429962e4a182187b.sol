1 pragma solidity 		^0.4.21	;							
2 										
3 interface IERC20Token {										
4 	function totalSupply() public constant returns (uint);									
5 	function balanceOf(address tokenlender) public constant returns (uint balance);									
6 	function allowance(address tokenlender, address spender) public constant returns (uint remaining);									
7 	function transfer(address to, uint tokens) public returns (bool success);									
8 	function approve(address spender, uint tokens) public returns (bool success);									
9 	function transferFrom(address from, address to, uint tokens) public returns (bool success);									
10 										
11 	event Transfer(address indexed from, address indexed to, uint tokens);									
12 	event Approval(address indexed tokenlender, address indexed spender, uint tokens);									
13 }										
14 										
15 contract	DTCC_ILOW_8		{							
16 										
17 	address	owner	;							
18 										
19 	function	DTCC_ILOW_8		()	public	{				
20 		owner	= msg.sender;							
21 	}									
22 										
23 	modifier	onlyOwner	() {							
24 		require(msg.sender ==		owner	);					
25 		_;								
26 	}									
27 										
28 										
29 										
30 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
31 										
32 										
33 	uint256	ID	=	1000	;					
34 										
35 	function	setID	(	uint256	newID	)	public	onlyOwner	{	
36 		ID	=	newID	;					
37 	}									
38 										
39 	function	getID	()	public	constant	returns	(	uint256	)	{
40 		return	ID	;						
41 	}									
42 										
43 										
44 										
45 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
46 										
47 										
48 	uint256	ID_control	=	1000	;					
49 										
50 	function	setID_control	(	uint256	newID_control	)	public	onlyOwner	{	
51 		ID_control	=	newID_control	;					
52 	}									
53 										
54 	function	getID_control	()	public	constant	returns	(	uint256	)	{
55 		return	ID_control	;						
56 	}									
57 										
58 										
59 										
60 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
61 										
62 										
63 	uint256	Cmd	=	1000	;					
64 										
65 	function	setCmd	(	uint256	newCmd	)	public	onlyOwner	{	
66 		Cmd	=	newCmd	;					
67 	}									
68 										
69 	function	getCmd	()	public	constant	returns	(	uint256	)	{
70 		return	Cmd	;						
71 	}									
72 										
73 										
74 										
75 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
76 										
77 										
78 	uint256	Cmd_control	=	1000	;					
79 										
80 	function	setCmd_control	(	uint256	newCmd_control	)	public	onlyOwner	{	
81 		Cmd_control	=	newCmd_control	;					
82 	}									
83 										
84 	function	getCmd_control	()	public	constant	returns	(	uint256	)	{
85 		return	Cmd_control	;						
86 	}									
87 										
88 										
89 										
90 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
91 										
92 										
93 	uint256	Depositary_function	=	1000	;					
94 										
95 	function	setDepositary_function	(	uint256	newDepositary_function	)	public	onlyOwner	{	
96 		Depositary_function	=	newDepositary_function	;					
97 	}									
98 										
99 	function	getDepositary_function	()	public	constant	returns	(	uint256	)	{
100 		return	Depositary_function	;						
101 	}									
102 										
103 										
104 										
105 // IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
106 										
107 										
108 	uint256	Depositary_function_control	=	1000	;					
109 										
110 	function	setDepositary_function_control	(	uint256	newDepositary_function_control	)	public	onlyOwner	{	
111 		Depositary_function_control	=	newDepositary_function_control	;					
112 	}									
113 										
114 	function	getDepositary_function_control	()	public	constant	returns	(	uint256	)	{
115 		return	Depositary_function_control	;						
116 	}									
117 										
118 										
119 										
120 	address	public	User_1		=	msg.sender				;
121 	address	public	User_2		;//	_User_2				;
122 	address	public	User_3		;//	_User_3				;
123 	address	public	User_4		;//	_User_4				;
124 	address	public	User_5		;//	_User_5				;
125 										
126 	IERC20Token	public	Securities_1		;//	_Securities_1				;
127 	IERC20Token	public	Securities_2		;//	_Securities_2				;
128 	IERC20Token	public	Securities_3		;//	_Securities_3				;
129 	IERC20Token	public	Securities_4		;//	_Securities_4				;
130 	IERC20Token	public	Securities_5		;//	_Securities_5				;
131 										
132 	uint256	public	Standard_1		;//	_Standard_1				;
133 	uint256	public	Standard_2		;//	_Standard_2				;
134 	uint256	public	Standard_3		;//	_Standard_3				;
135 	uint256	public	Standard_4		;//	_Standard_4				;
136 	uint256	public	Standard_5		;//	_Standard_5				;
137 										
138 	function	Eligibility_Group_1				(				
139 		address	_User_1		,					
140 		IERC20Token	_Securities_1		,					
141 		uint256	_Standard_1							
142 	)									
143 		public	onlyOwner							
144 	{									
145 		User_1		=	_User_1		;			
146 		Securities_1		=	_Securities_1		;			
147 		Standard_1		=	_Standard_1		;			
148 	}									
149 										
150 	function	Eligibility_Group_2				(				
151 		address	_User_2		,					
152 		IERC20Token	_Securities_2		,					
153 		uint256	_Standard_2							
154 	)									
155 		public	onlyOwner							
156 	{									
157 		User_2		=	_User_2		;			
158 		Securities_2		=	_Securities_2		;			
159 		Standard_2		=	_Standard_2		;			
160 	}									
161 										
162 	function	Eligibility_Group_3				(				
163 		address	_User_3		,					
164 		IERC20Token	_Securities_3		,					
165 		uint256	_Standard_3							
166 	)									
167 		public	onlyOwner							
168 	{									
169 		User_3		=	_User_3		;			
170 		Securities_3		=	_Securities_3		;			
171 		Standard_3		=	_Standard_3		;			
172 	}									
173 										
174 	function	Eligibility_Group_4				(				
175 		address	_User_4		,					
176 		IERC20Token	_Securities_4		,					
177 		uint256	_Standard_4							
178 	)									
179 		public	onlyOwner							
180 	{									
181 		User_4		=	_User_4		;			
182 		Securities_4		=	_Securities_4		;			
183 		Standard_4		=	_Standard_4		;			
184 	}									
185 										
186 	function	Eligibility_Group_5				(				
187 		address	_User_5		,					
188 		IERC20Token	_Securities_5		,					
189 		uint256	_Standard_5							
190 	)									
191 		public	onlyOwner							
192 	{									
193 		User_5		=	_User_5		;			
194 		Securities_5		=	_Securities_5		;			
195 		Standard_5		=	_Standard_5		;			
196 	}									
197 	//									
198 	//									
199 										
200 	function	retrait_1				()	public	{		
201 		require(	msg.sender == User_1			);				
202 		require(	Securities_1.transfer(User_1, Standard_1)			);				
203 		require(	ID == ID_control			);				
204 		require(	Cmd == Cmd_control			);				
205 		require(	Depositary_function == Depositary_function_control			);				
206 	}									
207 										
208 	function	retrait_2				()	public	{		
209 		require(	msg.sender == User_2			);				
210 		require(	Securities_2.transfer(User_1, Standard_2)			);				
211 		require(	ID == ID_control			);				
212 		require(	Cmd == Cmd_control			);				
213 		require(	Depositary_function == Depositary_function_control			);				
214 	}									
215 										
216 	function	retrait_3				()	public	{		
217 		require(	msg.sender == User_3			);				
218 		require(	Securities_3.transfer(User_1, Standard_3)			);				
219 		require(	ID == ID_control			);				
220 		require(	Cmd == Cmd_control			);				
221 		require(	Depositary_function == Depositary_function_control			);				
222 	}									
223 										
224 	function	retrait_4				()	public	{		
225 		require(	msg.sender == User_4			);				
226 		require(	Securities_4.transfer(User_1, Standard_4)			);				
227 		require(	ID == ID_control			);				
228 		require(	Cmd == Cmd_control			);				
229 		require(	Depositary_function == Depositary_function_control			);				
230 	}									
231 										
232 	function	retrait_5				()	public	{		
233 		require(	msg.sender == User_5			);				
234 		require(	Securities_5.transfer(User_1, Standard_5)			);				
235 		require(	ID == ID_control			);				
236 		require(	Cmd == Cmd_control			);				
237 		require(	Depositary_function == Depositary_function_control			);				
238 	}									
239 										
240 										
241 										
242 										
243 // Descriptif					0					
244 // Forme juridique					« Organisation autonome et décentralisée »					
245 // Dénomination					« MAGNITOGORSK-WINTERTHUR CONNECT »					
246 // Statut					« D.A.O. »					
247 // Propriétaires & responsables implicites					Le pool d’utilisateurs					
248 // Juridiction (i)					Ville de Magnitogorsk, Oblast de Chelyabinsk, Fédération de Russie					
249 // Juridiction (ii)					Ville de Winterthür, Canton de Zürich, Confédération Helvétique					
250 // instrument monétaire de référence (i)					« ethrub »					
251 // instrument monétaire de référence (ii)					« ethchf »					
252 // instrument monétaire de référence (iii)					« ethazn »					
253 // devise de référence (i)					« RUB »					
254 // devise de référence (ii)					« CHF »					
255 // devise de référence (iii)					« AZN »					
256 // Date de déployement initiale					20/09/2017					
257 // Environnement de déployement initial					suite protocolaire sur-couche « 88.2 » blockchain BITCOIN					
258 // Objet principal (i)					Gestion des activités post-marché					
259 // Objet principal (ii)					Contrepartie centrale					
260 // Objet principal (iii)					Garant					
261 // Objet principal (iv)					Dépositaire					
262 // Objet principal (v)					Teneur de compte					
263 // Objet principal (vi)					« Chambre de compensation »					
264 // Objet principal (vii)					Opérateur « règlement-livraison »					
265 // @ de communication additionnelle (i)					0xa24794106a6be5d644dd9ace9cbb98478ac289f5					
266 // @ de communication additionnelle (ii)					0x8580dF106C8fF87911d4c2a9c815fa73CAD1cA38					
267 // @ de publication additionnelle (protocole PP, i)					0xf7Aa11C7d092d956FC7Ca08c108a1b2DaEaf3171					
268 // @ de publication additionnelle (protocole PP, ii)					0x2Eab17625B3040E02c97cE84bEBEEc8eFA703ce4					
269 // Entité responsable du développement					Programme d’apprentissage autonome « KYOKO » / MS (sign)					
270 // Entité responsable de l’édition					Programme d’apprentissage autonome « KYOKO » / MS (sign)					
271 // Entité responsable du déployement initial					Programme d’apprentissage autonome « KYOKO » / MS (sign)					
272 										
273 										
274 }