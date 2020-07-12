package co.edu.javeriana.bot.interpreter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Function implements ASTNode {
	private String nombre;
	private List<String> parametros;
	private List<ASTNode> body;
	private Map<String, Object> tablaFuncion;	


	public Function(String nombre, List<String> parametros, List<ASTNode> body) {
		super();
		this.nombre = nombre;
		this.parametros = parametros;
		this.body = body;
		tablaFuncion = new HashMap<String, Object>();
	}


	@Override
	public Object execute(Map<String, Object> symbolTable) {
		tablaFuncion.put("parametros",parametros);
		for(String s: parametros) 
		{
			tablaFuncion.put(s,new Object());
		}
		tablaFuncion.put("body", body);
		symbolTable.put(nombre,tablaFuncion);
		return null;
	}

}
