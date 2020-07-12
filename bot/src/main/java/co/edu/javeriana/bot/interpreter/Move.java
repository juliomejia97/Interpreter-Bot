package co.edu.javeriana.bot.interpreter;

import java.util.Map;

import org.jpavlich.bot.Bot;

public class Move implements ASTNode {
	private ASTNode value;
	private Bot bot;
	private String side;


	public Move(ASTNode value, Bot bot, String side) {
		super();
		this.value = value;
		this.bot = bot;
		this.side = side;
	}





	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if(this.side.contentEquals("right")) 
		{
			bot.right((int)value.execute(symbolTable));
		}
		else if(this.side.contentEquals("left")) 
		{
			bot.left((int)value.execute(symbolTable));
		}
		else if(this.side.contentEquals("down")) 
		{
			bot.down((int)value.execute(symbolTable));
		}
		else if(this.side.contentEquals("up")) 
		{
			bot.up((int)value.execute(symbolTable));
		}
			
		return null;
	}

}
