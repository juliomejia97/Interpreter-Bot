package co.edu.javeriana.bot.interpreter;

import java.util.Map;

public class MenorEstricto implements ASTNode {
	private ASTNode expresion1;
	private ASTNode expresion2;
	
	public MenorEstricto(ASTNode expresion1, ASTNode expresion2) {
		super();
		this.expresion1 = expresion1;
		this.expresion2 = expresion2;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if (expresion1.execute(symbolTable).toString().contains(".")) {
			if(expresion2.execute(symbolTable).toString().contains(".")) {
				return (boolean)((double)expresion1.execute(symbolTable)<=(double)expresion2.execute(symbolTable));
			}else {
				return (boolean)((double)expresion1.execute(symbolTable)<=(int)expresion2.execute(symbolTable));
			}
		} else if(expresion2.execute(symbolTable).toString().contains(".")){
			return (boolean)((int)expresion1.execute(symbolTable)<=(double)expresion2.execute(symbolTable));
		}else {
			return (boolean)((int)expresion1.execute(symbolTable)<=(int)expresion2.execute(symbolTable));
		}
	}

}
