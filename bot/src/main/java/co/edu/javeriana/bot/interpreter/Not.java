package co.edu.javeriana.bot.interpreter;

import java.util.Map;

public class Not implements ASTNode {
	private ASTNode expresion;
	public Not(ASTNode expresion) {
		super();
		this.expresion = expresion;
	}
	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return (boolean)!(boolean) expresion.execute(symbolTable);
	}


}
