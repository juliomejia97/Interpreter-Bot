package co.edu.javeriana.bot.interpreter;

import java.util.List;
import java.util.Map;

public class Conditional implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> body;
	private List<ASTNode> elseBody;
	
	
	
	public Conditional(ASTNode condition, List<ASTNode> body, List<ASTNode> elseBody) {
		super();
		this.condition = condition;
		this.body = body;
		this.elseBody = elseBody;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if((boolean)condition.execute(symbolTable)) {
			for(ASTNode n: body) {
				n.execute(symbolTable);
			}
		}else {
			for(ASTNode n: elseBody) {
				n.execute(symbolTable);
			}
		}
		return null;
	}

}
