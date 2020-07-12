package co.edu.javeriana.bot.interpreter;

import java.util.Map;
import java.util.Scanner;

public class Read implements ASTNode {
	private String nombre;
	
	public Read(String nombre) {
		super();
		this.nombre = nombre;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		Scanner entrada = new Scanner(System.in);
		String mensaje =  entrada.nextLine();
		symbolTable.put(nombre, mensaje);
		return null;
	}

}
