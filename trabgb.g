grammar trabgb;

options {
    language=Java;
}

@header {
    import java.util.HashMap;
}

@members {
    HashMap<String, Double> ids = new HashMap<>();
}

programa 
	: comando+ 
	;

comando	
	: atribuicao SEMICOLON
	| teste
	| iteracao
	;

atribuicao
	: VAR { System.out.println("Variável: " + $VAR.text); }
	OPERADOR_ATRIBUICAO e = expressao_aritmetica
	{
		if(ids.containsKey($VAR.text)){
			System.out.println("Id atualizado: " + $VAR.text + " = " + $e.v);
		}else {
			System.out.println("Id novo inserido: " + $VAR.text + " = " + $e.v);
		}
		ids.put($VAR.text, new Double($e.v)); 
	
	}
	;

teste 
	: IF expressao_relacional THEN programa (ELSE programa)?
	;	 

iteracao 
	: WHILE expressao_relacional DO programa 
	;

expressao_aritmetica returns [ double v ]
	: 
	( 
	CONST { $v = Double.parseDouble($CONST.text); } {System.out.println("Constante: " + $v);}
	| VAR { $v = ids.getOrDefault($VAR.text, 0.0); } {System.out.println("Variável: " + $VAR.text + " = " + $v);}
	)
	( {System.out.println("Operação: +");} SOMA e = expressao_aritmetica {System.out.println("Cálculo: "+$v+" + "+$e.v);} {$v += $e.v;} {System.out.println("Resultado da soma: " + $v);}
	| {System.out.println("Operação: -");} SUBT e = expressao_aritmetica {System.out.println("Cálculo: "+$v+" - "+$e.v);} {$v -= $e.v;} {System.out.println("Resultado da subtração: " + $v);}
	| {System.out.println("Operação: *");} MULT e = expressao_aritmetica {System.out.println("Cálculo: "+$v+" * "+$e.v);} {$v *= $e.v;} {System.out.println("Resultado da multiplicação: " + $v);}
	| {System.out.println("Operação: /");} DIVI e = expressao_aritmetica {System.out.println("Cálculo: "+$v+" / "+$e.v);} {$v /= $e.v;} {System.out.println("Resultado da divisão: " + $v);}
	)?
	| L_PAREN e = expressao_aritmetica {$v = $e.v;} R_PAREN
	;

expressao_relacional returns [ boolean t ]
	: 
	( e = expressao_aritmetica ) 
	( {System.out.println("Expressão relacional: = " );} IGUAL d = expressao_aritmetica {$t = $e.v == $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " = "  + $d.v + " : " + $t);} 
	| {System.out.println("Expressão relacional: <>" );} DIF d = expressao_aritmetica {$t = $e.v != $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " <> " + $d.v + " : " + $t);} 
	| {System.out.println("Expressão relacional: < " );} MENOR d = expressao_aritmetica {$t = $e.v <  $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " < "  + $d.v + " : " + $t);}
	| {System.out.println("Expressão relacional: > " );} MAIOR d = expressao_aritmetica {$t = $e.v >  $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " > "  + $d.v + " : " + $t);} 
	| {System.out.println("Expressão relacional: <=" );} MENOR_IGUAL d = expressao_aritmetica {$t = $e.v <= $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " <= " + $d.v + " : " + $t);}
	| {System.out.println("Expressão relacional: >=" );} MAIOR_IGUAL d = expressao_aritmetica {$t = $e.v >= $d.v;} {System.out.println("Resultado Expressão relacional: " + $e.v + " >= " + $d.v + " : " + $t);}
	)   
	;

DO	:	'do';
ELSE	:	'else';
IF	:	'if';
RETURN	:	'return';
WHILE	:	'while';
THEN	:	'then';
SOMA 	:	'+';
SUBT	:	'-';
MULT	:	'*';
DIVI	:	'/';
L_PAREN	:	'(';
R_PAREN	:	')';
IGUAL 	:	'=';
DIF	:	'<>';
MAIOR	:	'>';
MENOR	:	'<';
MAIOR_IGUAL
	:	'>=';
MENOR_IGUAL
	:	'<=';


OPERADOR_ATRIBUICAO: ':=' ;
//OPERADOR_RELACIONAL: '<' | '>' | '>=' | '<=' | '<>' | '=';
SEMICOLON: ';';

CONST : ('0'..'9')+ ;
VAR  : ('a'..'z'|'A'..'Z')+;

WS  : (' '|'\n'|'\r'|'\t')+ {skip();} ;