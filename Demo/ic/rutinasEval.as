#include "rutinasOA.as"
//rutinas.as file..............
// Este documento contiene todas las rutinas necesarias para el funcionamiento de los cursos ABC de TECADI
// Las funciones que se encontraran son las siguientes:
// cargar();
// adelante();
// codigoIntro();
// codigoIntroduccion();
// codigoIntroExamen();
// cierre();
// salida();
// salidaExamen();
//----Author Tecadi -------
//----Tecnologías en Adiestramiento..............
//----Fecha Creado: 07 Junio 2004......
// Fecha ultima actualización: 28 de febero de 2006
//Por:Servicios en Aprendizaje y tecnología
//---------------------------------------------------
// Funcion: cargar
// Descripción: Se encarga de mostrar la carga del swf cuando este se encuentra alojado en una intranet o internet
// Retorna: Porcentaje de carga del archivo swf
// Movieclips asociados: Utiliza el movieClip "carga_mc" que debe de encontrarse en el libro swf
_global.cargar = function() {
	total = _root.getBytesTotal();
	cargados = _root.getBytesLoaded();
	if (cargados == total) {
		nextScene();
		play();
	}
	porcentaje = Math.floor((cargados*100)/total);
	_root.carga_mc.porcentaje.text = porcentaje+" %";
	// definiendo tamaño barra
	_root.carga_mc.barra._xscale = porcentaje;
};
//para saber el estandar del ABC
_global.estandarABC=function(abcXML){
    cargarxml(abcXML);
    _global.Doc.onLoad = function() {
 	     _global.nodeDocABC = _global.Doc.childNodes;
		 _global.nodeABC=_global.nodeDocABC[0];    
		 _global.std = _global.nodeABC.childNodes[2].childNodes;
		 
	};
}
//////////////////////////////////////////////////////////////////////////////////////////
// Códigos relacionados con las evaluaciones
//////////////////////////////////////////////////////////////////////////////////////////
_global.codigoIntroduccion = function(nombreE) {
	estandarABC("ABC.xml");
   //Declaracion de variables a utilizar en la programacion del examen
   // Arreglo que guarda los feedback finales
	var quizDoc = new XML();
	// objeto que guarda la informacion del XML
	quizDoc.ignoreWhite = true;
	quizDoc.load(nombreE);
	// carga del XML
	quizDoc.onLoad = function() {
		   _level1.textointroduccion ="Exito";
		   var quizNode = quizDoc.childNodes;
			var nodo = quizNode[0].childNodes;//nodo examen
			caracteristicas = nodo[0].childNodes;
		// titulo del abc
   		  _level1.nomabc = caracteristicas[0].firstChild.nodeValue;
		  _level1.tituloeval = caracteristicas[1].firstChild.nodeValue;
		// variable que guarda si la evaluacion es un gimnasio o examen
			tipoExamen = caracteristicas[2].firstChild.nodeValue;
		//Texto de la introduccion del examen	
   		   _level1.textointroduccion =nodo[1].firstChild.nodeValue;
		    nroamostrar = caracteristicas[3].firstChild.nodeValue;
		   _global.titulo = caracteristicas[1].firstChild.nodeValue;
	};
};
/////////////////////////////////////////////////////
// Código del examen
/////////////////////////////////////////////////////
function codigoExamen(nombreE) {
	//  Declaracion de variables a utilizar en la programacion del examen
	var valorporcentaje = 0; 
	var incorrectas = 0; 
	var correctas = 0; 
	var totalc = 0;  // nro de preguntas contestadas correctamente
	var currentQuestion = 0;			// nro de pregunta actual
	_global.userAnswers = new Array();  	// arreglo que guarda las opciones seleccionadas por el usuario
	_global.questionsArray = new Array();	// arreglo que guarda las preguntas traidas del XML
	_global.preSeleccionada = new Array();	// arreglo que guarda las preguntas que fueron seleccionadas en la aleatoriedad
	_global.final = new Array();	// Arreglo que guarda los feedback finales
	_global.quizDoc = new XML();			

	// objeto que guarda la informacion del XML
	quizDoc.ignoreWhite = true;
	quizDoc.load(nombreE);// carga del XML
	//quizDoc.load("gymL11.xml");// carga del XML
	quizDoc.onLoad = function() {
			ConstruyeArregloPreguntas();
	}
}
// Funcion: ConstruyeArregloPreguntas()
// Descripción: construye el arreglo que contendra todas las preguntas traidas del XML
// Retorna: El Arreglo 
function ConstruyeArregloPreguntas() {
	//stripWhitespaceDoublePass(quizDoc);
	var quizNode = quizDoc.childNodes;
	var nodo = quizNode[0].childNodes;
	caracteristicas = nodo[0].childNodes;
	tipoExamen = caracteristicas[2].firstChild.nodeValue;
	// variable que guarda si la evaluacion es un gimnasio o examen
	nroaMostrar = caracteristicas[3].firstChild.nodeValue;
	
	// variable que contiene el valor de las preguntas a mostrar
	feedbackfinal = nodo[2].childNodes;
	// contiene los feedback finales	
	nrofeedback = feedbackfinal.length;
	for (var i = 0; i<nrofeedback; i++) {
		var thisChoice = feedbackfinal[i];
		_global.final[i] = thisChoice.firstChild.nodeValue;
	}
	preguntas = nodo[3].childNodes;
	nroquestion = preguntas.length;
	//por cada nodo de pregunta esta se guarda en un arreglo
	for (var i = 0; i<nroquestion; i++) {
		// asigna referencia a la actual pregunta
		var thisQuestion = preguntas[i];
		var choicesArray = new Array();
		// se construye un arreglo con las opciones de la pregunta actual
		nropciones = thisQuestion.childNodes.length;
		for (var j = 0; j<nropciones; j++) {
			var thisChoice = thisQuestion.childNodes[j];
			choicesArray[j] = thisChoice.firstChild.nodeValue;
			if (thisChoice.attributes.correcta == 1) {
				respuesta = j;
			}
			//trace(thisChoice.firstChild.nodeValue.attributes.correcta);
		}
		// constructor del objeto Question
		_global.questionsArray[i] = new Question(respuesta, choicesArray[0], choicesArray);
	}
	// 
	loadMsg = "";
	// Comienza el quiz
	// selecciona el indice del arreglo aleatoriamente, para seleccionar una pregunta aleatoria
	nropregunta = random(nroquestion);
	_global.preSeleccionada[0] = nropregunta;
	makeQuestion(0, nropregunta);
}
// Funcion Question
// Constructor del objeto Question
function Question(correctAnswer, questionText, answers) {
	this.correctAnswer = correctAnswer;
	this.questionText = questionText;
	this.answers = answers;
}
// Funcion que aparece la pregunta en la pantalla usando distintos movieclip´s
function makeQuestion(currentQ, nropregunta) {
	// borra en la escena la ultima pregunta presentada
	enunciado_mc.removeMovieClip();
	attachMovie("error", "error_mc", 10);
	error_mc._x = 400;
	error_mc._y = 280;
	error_mc.gotoAndStop(1);
	if (tipoExamen == "gimnasio") {
		mala.removeMovieClip();
		buena.removeMovieClip();
	}
	// crea y coloca la pregunta en un movieclip
	attachMovie("enunciados", "enunciado_mc", 0);
	enunciado_mc._x = _global.Xenunciado;
	enunciado_mc._y = _global.Yenunciado;
	enunciado_mc.qNum = "Pregunta "+(currentQ+1)+" de "+nroaMostrar;
	enunciado_mc.enun_txt.multiline = true;
	enunciado_mc.enun_txt.autosize = true;
	qText = ""+_global.questionsArray[nropregunta].questionText;
	enunciado_mc.enun_txt.text = qText;
	// crea las opciones de la pregunta colocandolas en un movieclip
	nropciones = _global.questionsArray[nropregunta].answers.length;
	if (tipoExamen == "gimnasio") {
		nropciones = nropciones-3;
	} else {
		nropciones = nropciones-1;
	}
	for (var i = 0; i<nropciones; i++) {
		enunciado_mc.attachMovie("opciones", "opcion"+(i+1), i);
		nombreclip = "opcion"+(i+1);
		enunciado_mc[nombreclip]._y += _global.separacion+(i*_global.Yopciones);
		enunciado_mc[nombreclip]._x -= _global.Xopciones;
		enunciado_mc[nombreclip].answerText = _global.questionsArray[nropregunta].answers[i+1];
	}
}
//  Funcion: opcionSeleccionada
//  demuestra el Feedback positivo y negativo
_global.opcionSeleccionada = function(choice, nombreopcion) {
	//añade la seleccion a un arreglo userAnswer
	_global.userAnswers.push(choice);
	nropciones = _global.questionsArray[nropregunta].answers.length;
	if (tipoExamen == "gimnasio") {
		if (choice == _global.questionsArray[nropregunta].correctAnswer) {
			// presenta el feedback positivo mostrando la respuesta a traves de un movieclip
			resbuena = _global.questionsArray[nropregunta].answers[nropciones-2];
			enunciado_mc[nombreopcion].gotoAndStop("verdadero");
			buena.removeMovieClip();
			attachMovie("resBuena", "buena", 50);
			sonido("bien");
			buena._x = Xrespuesta;
			buena._y = Yrespuesta;
			buena.resbuena = resbuena;
		} else {
			// presenta el feedback negativo mostrando la respuesta a traves de un movieclip
			mala.removeMovieClip();
			resmala = _global.questionsArray[nropregunta].answers[nropciones-1];
			enunciado_mc[nombreopcion].gotoAndStop("falso");
			attachMovie("resMala", "mala", 50);
			sonido("mal");
			mala._x = Xrespuesta;
			mala._y = Yrespuesta;
			mala.resmala = resmala;
		}
		deshabilitar(nropciones, choice);
	} else {
		enunciado_mc[nombreopcion].gotoAndStop("marcado");
		deshabilitar(nropciones, choice);
	}
};
function deshabilitar(nropciones, choice) {
	for (var i = 0; i<nropciones; i++) {
		if (i<>choice) {
			nombreopcion = "opcion"+i;
			enunciado_mc[nombreopcion].gotoAndStop("normal");
		}
	}
}
// Funcion nextQ
// Sigue a la siguiente pregunta y si es el final ejecuta la funcion resultadoFinal
_global.nextQ = function() {
	if (currentQ+1 == nroaMostrar) {
		if (tipoExamen == "gimnasio") {
			mala.removeMovieClip();
			buena.removeMovieClip();
		}
		enunciado_mc.removeMovieClip();
		resultadoFinal();
	} else {
		revisaPregunta();
		_global.preSeleccionada.push(nropregunta);
		currentQ = currentQ+1;
		makeQuestion(currentQ, nropregunta);
	}
};
// Funcion revisaPregunta
// antes de pasar a la siguiente pregunta revisa si la pregunta realizando la aleatoriedad ya fue seleccionada
// si es asi se vuelve a escoger otro valor de aleatorio
function revisaPregunta() {
	nropregunta = random(nroquestion);
	for (var i = 0; i<_global.preSeleccionada.length; i++) {
		if (nropregunta == _global.preSeleccionada[i]) {
			valor = true;
			i = _global.preSeleccionada.length;
		} else {
			valor = false;
		}
	}
	if (valor) {
		revisaPregunta();
	}
}

// Funcion ResultadoFinal
function resultadoFinal() {
	// Cuenta cuantas preguntas estuvieron buenas
	totalc =0;
	for (var i = 0; i< _global.preSeleccionada.length; i++)
	{
		seleccionada = _global.preSeleccionada[i];
		preguntaCorrecta = _global.questionsArray[seleccionada].correctAnswer;
		_root.nro1.text = preguntaCorrecta;
		if (_global.userAnswers[i] == preguntaCorrecta)
		{

			totalc++;
		}
	}
	// asigna a cada variable el valor de las correctas, incorrectas y el porcentaje
	incorrectas = nroaMostrar-totalc;
	correctas = totalc;
	valorporcentaje = Math.round(((correctas*100)/nroaMostrar));
	valor = valorporcentaje;
	porcentaje = valorporcentaje+"%";
	_level0.puntaje=valor;
	// movieclip que demuestra el resultado
	_global.llegoalfinal=true;
	finalPop_mc.correctas = correctas;
	finalPop_mc.incorrectas = incorrectas;
	finalPop_mc.porcentaje= porcentaje;
	if (_level0.LMS <> "false") {
		adelante_mc.gotoAndPlay("deshabilitado");
	}
	finalPop_mc.gotoAndPlay(2);
	//escribiendo en LMS la nota
	variable="E"+_global.estandar;
	if(variable=="Escorm"){
	    _global.funciones_LMS();
	}
	
}
// Funcion Sonido
// Ejecuta el sonido bien y mal que se encuentran en la libreria
function sonido(tipo) {
	song = new Sound();
	song.attachSound(tipo);
	song.start();
}
// ### Strips whitespace nodes from an XML document 
// ### by passing twice through each level in the tree
function stripWhitespaceDoublePass(XMLnode) {
	// Loop through all the children of XMLnode
	for (var i = 0; i<XMLnode.childNodes.length; i++) {
		// If the current node is a text node...
		if (XMLnode.childNodes[i].nodeType == 3) {
			// ...check for any useful characters in the node.
			var j = 0;
			var emptyNode = true;
			for (j=0; j<XMLnode.childNodes[i].nodeValue.length; j++) {
				// A useful character is anything over 32 (space, tab, 
				// new line, etc are all below).
				if (XMLnode.childNodes[i].nodeValue.charCodeAt(j)>32) {
					emptyNode = false;
					break;
				}
			}
			// If no useful charaters were found, delete the node.	
			if (emptyNode) {
				XMLnode.childNodes[i].removeNode();
			}
		}
	}
	// Now that all the whitespace nodes have been removed from XMLnode,
	// call stripWhitespaceDoublePass on its remaining children.
	for (var k = 0; k<XMLnode.childNodes.length; k++) {
		stripWhitespaceDoublePass(XMLnode.childNodes[k]);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
_global.verificafondo = function() {
	//	((es <> "menuleccion") or (
	if (es<>"gimnasio") {
		if (es<>"menuleccion") {
			etiqueta = "L"+modulo+leccion;
			_level0.fondos_mc.gotoAndStop(etiqueta);
		}
	} else {
		_level0.fondos_mc.gotoAndStop(1);
	}
};

function formatoTiempo(t) {
	x = 3600;
	y = 60;
	h = Math.round(t/x-t%x/x)+'';
	m = Math.round((t-h*x)/y-(t-h*x)%y/y)+'';
	var s = Math.round(t-h*x-m*y)+'';
	if (h.toString().length == 1) {
		h = '0'+h;
	}
	if (m.toString().length == 1) {
		m = '0'+m;
	}
	if (s.toString().length == 1) {
		s = '0'+s;
	}
	gTime = h+":"+m+":"+s;
	return gTime;
}
function calcularTiempo() {
	tiempototal = int(getTimer()/1000);
	tiempoleccion = tiempototal-_level1.tiempo;
	tiem = formatotiempo(tiempoleccion);
	return tiem;
}
function registroASP() {
	if (_level0.tipo == "registro") {
		tiempo = calcularTiempo();
		actual = "L"+_level1.modulo+_level1.leccion;
		direccion = "../guardaReg.asp?tiempo="+tiempo+"&actual="+actual;
		fscommand("IraPagina", direccion);
	}
}

_global.cierre = function() {
	unloadMovieNum(30);
   loadMovie("x.swf", 30);
};

_global.salida = function() {
	//_global.funciones_LMS();
	 _global.fin=1;
	 variable="E"+_global.std;
	 if(variable == "Eaicc"){
	 	_global.funciones_LMS();
	 }
	 
};
//Declaro las variables para enviar 
_global.registrarCookie = function() {
	if (_level0.tipo == "registro") {
		import mx.controls.Alert;
		if ((nombre == '') and (id == '')) {
			_level1.Alert.okLabel = "Aceptar";
			_level1.Alert.buttonWidth = 75;
			_level1.Alert.show("Debe de llenar los campos para realizar el registro. Por favor, revise el formulario.", "Advertencia", Alert.OK, null, alClicar, "prueba", Alert.OK);
		} else {
			direccion = "../writeCookie.asp?nombre="+nombre+"&id="+id;
			fscommand("IraPagina", direccion);
			tellTarget (_level1) {
				play();
			}
		}
	}
};
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
// Final rutinasEval
