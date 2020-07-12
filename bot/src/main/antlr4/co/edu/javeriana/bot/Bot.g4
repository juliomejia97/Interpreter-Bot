grammar Bot;

@header {

import org.jpavlich.bot.*;
import java.util.Map;
import java.util.HashMap;
import co.edu.javeriana.bot.interpreter.*;
}

@parser::members {

private Bot bot;
private Map <String, Object> symbolTable = new HashMap<String, Object>();

public BotParser(TokenStream input, Bot bot) {
    this(input);
    this.bot = bot;
    }
}

program returns [ASTNode node]: 
	{
		List<ASTNode> bodyProgram = new ArrayList<ASTNode>();
		Map<String, Object> symbolTable = new HashMap<String,Object>();
	}
		(sentence {bodyProgram.add($sentence.node);
		})*
	{
		for(ASTNode n: bodyProgram)
		{
			n.execute(symbolTable);
		}
	};


sentence returns [ASTNode node]: writeln {$node = $writeln.node;} 
		| conditional {$node = $conditional.node;}
		| var_decl {$node = $var_decl.node;}
		| var_assign{$node = $var_assign.node;}
		| move{$node = $move.node;}
		| action{$node = $action.node;}
		| ciclo{$node = $ciclo.node;}
		| function{$node = $function.node;}
		| invoca_function{$node = $invoca_function.node;}
		|leer {$node = $leer.node;};
		
function returns [ASTNode node]: FUNCION  d1 = ID 
	PARENTESISIZQUIERDO  
	{
		List<String> parametros = new ArrayList<String>();
	}(DECLARACION d2 = ID{parametros.add($d2.text);})* PARENTESISDERECHO
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	} 
	BEGIN 
		(sentence{body.add($sentence.node);})*
	END PUNTOYCOMA
	{
		$node = new Function($d1.text, parametros, body);
	};

invoca_function returns [ASTNode node]:
	ID PARENTESISIZQUIERDO 
	{
		List<ASTNode> parametros = new ArrayList<ASTNode>();
	} 
	(expresion{parametros.add($expresion.node);})*
	PARENTESISDERECHO PUNTOYCOMA
	{
		$node = new Invoc_Function($ID.text, parametros);
	};
	
leer returns [ASTNode node]:
		INPUT ID PUNTOYCOMA {$node = new Read($ID.text);};
				
expresionLogica returns [ASTNode node]:
		NOT PARENTESISIZQUIERDO operadorOR PARENTESISDERECHO{$node = new Not($operadorOR.node);}
		|operadorOR {$node = $operadorOR.node;};
		
operadorOR returns [ASTNode node]:
		(o1 = operadorAND {$node = $o1.node;}
		| PARENTESISIZQUIERDO t1 = operadorAND {$node = $t1.node;}PARENTESISDERECHO
		)
		(OR o2 = operadorAND {$node = new Or($node, $o2.node);}
		|OR PARENTESISIZQUIERDO o2 = operadorAND{$node = new Or($node, $o2.node);} PARENTESISDERECHO)*;
operadorAND returns [ASTNode node]:
	(c1 = comparar{$node = $c1.node;}
	|PARENTESISIZQUIERDO c1 = comparar{$node = $c1.node;} PARENTESISDERECHO
	|NOT PARENTESISIZQUIERDO c1 = comparar{$node = new Not($c1.node);} PARENTESISDERECHO)
	(AND c2 = comparar{$node = new And($node,$c2.node);}
	| AND PARENTESISIZQUIERDO c2 = comparar{$node = new And($node,$c2.node);} PARENTESISDERECHO
	|AND NOT PARENTESISIZQUIERDO c2 = comparar{$node = new And($node,new Not($c2.node));} PARENTESISDERECHO)*;

comparar returns [ASTNode node]:
		c1 = expresion {$node = $c1.node;}
		((MAYOR c2 = expresion{$node = new MayorAbierto($node,$c2.node);}
		| MENOR c2 = expresion{$node = new MenorAbierto($node,$c2.node);}
		|MAYORIGUAL c2 = expresion{$node = new MayorEstricto($node,$c2.node);}
		|MENORIGUAL c2 = expresion{$node = new MenorEstricto($node,$c2.node);}
		|IGUAL c2 = expresion{$node = new IgualQue($node,$c2.node);}
		|DIFERENTE c2 = expresion{$node = new Diferente($node, $c2.node);}))?;

expresion returns [ASTNode node]:
		a1=term{$node = $a1.node;}
			(SUMA a2=factor {$node = new Addition($node, $a2.node);}
			| RESTA a2=factor {$node = new Resta($node, $a2.node);}
			)*;
factor returns [ASTNode node]: t1=term {$node = $t1.node;}
		(MULTIPLICACION t2=term {$node = new Multiplicacion($node, $t2.node);}
		| DIVISION t2=term{$node = new Division($node, $t2.node);}
		)*;

term returns[ASTNode node]: 
	ENTEROS {$node = new Constant(Integer.parseInt($ENTEROS.text));}
	| BOOLEAN {$node = new Constant(Boolean.parseBoolean($BOOLEAN.text));}
	| ID{$node = new VarRef($ID.text);}
	| CADENA{$node = new Constant($CADENA.text);}
	| PARENTESISIZQUIERDO expresion {$node = $expresion.node;} PARENTESISDERECHO;
	

writeln returns[ASTNode node]: OUTPUT expresion PUNTOYCOMA
			{$node = new Println($expresion.node);};

conditional returns [ASTNode node]: IF PARENTESISIZQUIERDO expresionLogica PARENTESISDERECHO
					{
						List<ASTNode> body = new ArrayList<ASTNode>();
						List<ASTNode> elseBody = new ArrayList<ASTNode>();
					}
					BEGIN (s1 = sentence {body.add($s1.node);})* END PUNTOYCOMA
					(ELSE
					{
						
					}
					BEGIN (s2 = sentence {elseBody.add($s2.node);})* END PUNTOYCOMA)?
					
					{
						
						$node = new Conditional($expresionLogica.node,body, elseBody);
					};
					
ciclo returns [ASTNode node]: WHILE PARENTESISIZQUIERDO expresionLogica PARENTESISDERECHO
						{
							List<ASTNode> body = new ArrayList<ASTNode>();
						} 
						BEGIN ( sentence{body.add($sentence.node);})* END PUNTOYCOMA
						{
							$node = new Ciclo($expresionLogica.node, body);
						};
					
var_decl returns [ASTNode node] : DECLARACION ID PUNTOYCOMA 
		{
			$node = new Var_decl($ID.text);
		};
var_assign returns [ASTNode node] : ID ASIGNACION expresion PUNTOYCOMA 
		{
			$node = new Var_Assign($ID.text,$expresion.node);
		}
		|DECLARACION ID ASIGNACION expresion PUNTOYCOMA 
		{
		 	$node = new Var_Assign($ID.text, $expresion.node);
		};
move returns[ASTNode node]: side expresion PUNTOYCOMA
		{
			$node = new Move($expresion.node,bot,$side.value);
		};

action returns [ASTNode node]: PICK PUNTOYCOMA{$node = new ActionR($PICK.text, bot);} 
				| DROP PUNTOYCOMA{$node = new ActionR($DROP.text, bot);}
				| LOOK PUNTOYCOMA{$node = new ActionR($LOOK.text, bot);};

side returns [String value] : UP {$value = $UP.text;}
							|DOWN {$value = $DOWN.text;} 
							|LEFT {$value = $LEFT.text;}
							| RIGHT {$value = $RIGHT.text;}; 
// Los tokens se escriben a continuaciÃ³n de estos comentarios.
// Todo lo que estÃ© en lÃ­neas previas a lo modificaremos cuando hayamos visto AnÃ¡lisis SintÃ¡ctico

/*
 * La declaración de los tokens
 */
IF: 'if';
ELSE: 'else';
ASIGNACION: '=';
DECLARACION: 'let';
WHILE: 'while';
INPUT: 'read';
OUTPUT: 'writeln'|'write';
BEGIN: 'begin';
END: 'end';
FUNCION: 'function';

/*
 * Operadores de mover el robot
 */
UP: 'up';
DOWN: 'down';
LEFT: 'left';
RIGHT: 'right';
PICK: 'pick';
DROP: 'drop';
LOOK: 'look';

/*
 * Declaración de los operadores aritméticos
 */
SUMA: '+';
RESTA: '-';
MULTIPLICACION: '*';
DIVISION:'/';

/*
 * Declaración de valores lógicos
 */
AND: 'and';
OR: 'or';
NOT: 'not';
MENOR: '<';
MAYOR: '>';
MENORIGUAL: '<=';
MAYORIGUAL:'>=';
IGUAL: '==';
DIFERENTE: '<>';

/*
 * Declaración de parentésis y puntos y comas 
 */
PUNTOYCOMA: ';';
PARENTESISIZQUIERDO: '(';
PARENTESISDERECHO: ')';
LLAVEOP:'{';
LLAVECL: '}';

/*
 * Valores
 */
BOOLEAN: 'true'|'false';
ID: [a-zA-Z] [a-zA-Z0-9]*;
ENTEROS: [0-9]+;
CADENA: '"'~'"'*'"';
DECIMALES: [0-9]+ ('.'[0-9]+)?;

///Falta expresión regular para condición

WS
:
	[ \t\r\n]+ -> skip 
;