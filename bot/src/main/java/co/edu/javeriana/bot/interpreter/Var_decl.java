package co.edu.javeriana.bot.interpreter;

import java.util.Map;

public class Var_decl implements ASTNode{
	private String name;
	
	
	
	public Var_decl(String name) {
		super();
		this.name = name;
	}



	public Object execute(Map<String, Object> symbolTable) {
		symbolTable.put(name, new Object());
		return null;
	}
}
