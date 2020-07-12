package co.edu.javeriana.bot.interpreter;

import java.util.Map;

public class Var_Assign implements ASTNode {
	private String name;
	private ASTNode expression;
	
	

	public Var_Assign(String name, ASTNode expression) {
		super();
		this.name = name;
		this.expression = expression;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		symbolTable.put(name, expression.execute(symbolTable));
		return null;
	}

}
