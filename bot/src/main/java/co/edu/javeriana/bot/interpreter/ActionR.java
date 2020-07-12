package co.edu.javeriana.bot.interpreter;

import java.util.Map;

import org.jpavlich.bot.Bot;

public class ActionR implements ASTNode {
	private String action;
	private Bot bot;
	
	public ActionR(String action, Bot bot) {
		super();
		this.action = action;
		this.bot = bot;
	}


	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if(this.action.contentEquals("pick"))
			bot.pick();
		else if(this.action.contentEquals("drop"))
			bot.drop();
		else
			System.out.print(bot.look());
		return null;
	}

}
