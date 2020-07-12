package co.edu.javeriana.bot.interpreter;

import java.util.Map;

public class Or implements ASTNode {
	private ASTNode c1;
	private ASTNode c2;
	
	public Or(ASTNode c1, ASTNode c2) {
		super();
		this.c1 = c1;
		this.c2 = c2;
	}
	
	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return (boolean)c1.execute(symbolTable) || (boolean)c2.execute(symbolTable);
	}

}
