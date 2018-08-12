#include "rutinasLMS.as"
//rutinasLMS.as file..............
// Este documento contiene todas las rutinas necesarias para el funcionamiento de los cursos ABC
// Las funciones que se encontraran son las siguientes:
/*
cargar();
*/
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
		//stop();
	}
	porcentaje = Math.floor((cargados*100)/total);
	_root.carga_mc.porcentaje.text = porcentaje+" %";
	// definiendo tamaño barra
	_root.carga_mc.barra._xscale = porcentaje;
};
//**** FUNCION acciones del teclado en la ventana salir
//FUNCION para moviemitno del teclado en el ABC
_global.move_tecladoSalir =function(){
	var teclado2:Object = new Object();
    teclado2.onKeyDown = function() {
    trace(Key.getCode()); 
    switch (Key.getCode()) {
       case 27 :
            unloadMovieNum(30);
            break;
       case 13 :
         _global.salida();
         break;
     }
   };
Key.addListener(teclado2);
};
//*******
//FUNCION para moviemitno del teclado en el ABC
_global.move_teclado =function(){
	var teclado:Object = new Object();
    teclado.onKeyDown = function() {
    trace(Key.getCode()); 
    switch (Key.getCode()) {
       case 27 :
            cierre();
            break;
       case 38 :
         _global.iramenu();  
         break;
       case 39 :
          _global.adelantebloque();
          if(_global.contadorbloque == _global.nrobloques){
    	     gotoAndStop("deshabilitado");
  	      }
          break;
       case 40 :
           _global.repetir();
           break;
       case 37 :
           _global.atrasbloque();
           break; 
     }
   };
Key.addListener(teclado);
	
	
};
//Funcion que determina el tiempo de inactividad del usuario en el ABC
_global.determinar_tiempo = function (){
// tiempo_maximo_inactivo (en segundos)
var tiempo_maximo_inactivo = 3600;
// tiempo_ultima_vez_activo (en milisegundos)
var tiempo_ultima_vez_activo = getTimer();
function comprobar() {
     if (getTimer()-tiempo_ultima_vez_activo>tiempo_maximo_reposo*1000) {
     // aquí las acciones cuando se supere el tiempo máximo inactivo
        loadMovie("tiempo.swf", 30);   
      // clearInterval(interval_idle);
    }
}
// cuando muevo el ratón, se inicia la vble
this.onMouseMove = function() {
   tiempo_ultima_vez_activo = getTimer();
   //unloadMovie(30);
};
// para no sobrecargar la película, evitamos el uso
// de un onEnterFrame y empleamos setInterval
 interval_idle = setInterval(comprobar, 10000); 
}

//funcion que carga las variables del Base con lo que trae el XML
function mostrarbloque1(){
	 conocerABC("ABC.xml");
    _level0.leccion = _global.leccion;
    _level0.nombreOA = _global.nombreOA;
	
}
//******************************************************************************************
//Funciones de comportamientos de objetos varios: boton de instrucciones, otros
//******************************************************************************************
//*** BOTON ADELANTE ****
_global.adelantebloque=function () {
	 stopAllSounds();
	_global.contadorbloque =_global.contadorbloque + 1;
	_level0.atras_mc.gotoAndStop("habilitado");
	if (_global.contadorbloque <=_global.nrobloques){
		 proximobloque = "bloque"+_global.contadorbloque;
		 _level1.gotoAndPlay(proximobloque,proximobloque);
 		  datosbloque(_global.contadorbloque);
	   _level1.play();
	 }

//****** para verificar estatus del tema y escribir en el LMS *****
    _global.funciones_LMS();
//Fin de escritura en el LMS ****		 
};
//*** BOTON ATRAS ******
_global.atrasbloque=function () {
	 stopAllSounds();
    _level0.adelante_mc.gotoAndStop("habilitado");
	if (_global.contadorbloque > 1){
		 nro = _global.contadorbloque-1;
		 _global.contadorbloque = _global.contadorbloque-1;
		 anteriorbloque = "bloque"+_global.contadorbloque;
		 _level1.gotoAndPlay(anteriorbloque,anteriorbloque);
		if (nro == 1)  {
		  _level0.atras_mc.gotoAndStop("deshabilitado");
		}
		 datosbloque(_global.contadorbloque);

		_level1.play();			
	 }
};
//*** BOTON REPETIR ******
_global.repetir = function() {
	stopAllSounds();
	 repetirbloque = "bloque"+_global.contadorbloque;
	_level1.gotoAndPlay(repetirbloque, repetirbloque);
    _level1.play();			
};
//*** BOTON SALIDA ******
_global.cierre = function() {
 	unloadMovieNum(30);
	//Mostrando el movie clip de cierre
	loadMovie("x.swf", 30);
};

_global.salida = function() {
	  _global.fin=1;
	  //_level0.nombreABC=_global.fin;
	  if(_global.fin == 1){
	      _global.funciones_LMS();
		  
	  }
};
//** UTILITARIOS MAPA - AYUDA -GLOSARIO
_global.iraglosario = function() {
	unloadMovieNum(2);
	getURL("javascript:void(window.open('uglosario.html','popup','toolbar=no,location=no,status=no,menubar=no, scrollbars=no,resizable=no,width=600,height=400,top=50,left=50'))");
};
_global.irayuda = function() {
	unloadMovieNum(2);
	if ((_level1.es == "null") and (_level0.LMS == "completo")) {
		getURL("javascript:void(window.open('uayuda.html','popup','toolbar=no,location=no,status=no,menubar=no, scrollbars=no,resizable=no,width=640 height=480,top=0,left=0'))");
	} else {
		getURL("javascript:void(window.open('uayuda.html','popup','toolbar=no,location=no,status=no,menubar=no, scrollbars=no,resizable=no,width=640,height=480,top=0,left=0'))");
	}
};
//carga del menu del superior 
_global.iramenu=function(nivel){
 	archivo =_global.menusup+".swf";
	unloadMovieNum(1);
	loadMovieNum(archivo, 1);
}

//**********************************
//*******************FIN FUNCIONES DE BOTONES *****************************************************
//Esta funcion coloca en los textos dinamicos los datos del bloque
function datosbloque(bloque){
    _level0.nombrebloque=_global.nodeBloques.childNodes[bloque-1].childNodes[0].childNodes;
    _level1.narracion=_global.nodeBloques.childNodes[bloque-1].childNodes[1].childNodes;
    _level1.texto=_global.nodeBloques.childNodes[bloque-1].childNodes[2].childNodes;
	//_level0.lain=_global.nodeBloques.childNodes[bloque-1].childNodes.length;
	for(var i=0;i<_global.nodeBloques.childNodes[bloque-1].childNodes.length;i++){ 
	     // _level0.lain=_global.nodeBloques.childNodes[bloque-1].childNodes[i].nodeName;
		// _level0.lain="Valor de i"+i;
		  variable="E"+_global.nodeBloques.childNodes[bloque-1].childNodes[i].nodeName;
	      if(variable =="EInstruccion"){
			   _level0.lain="Entro en la condición";
	          _level1.instruccion=_global.nodeBloques.childNodes[bloque-1].childNodes[i].childNodes;
  	          _level1.estado=_global.nodeBloques.childNodes[bloque-1].childNodes[i].attributes.estado;
 		      _
              //Este es el nodo que buscamos 
           break; 
         } 
     } 
	
	 //esta linea pasa a ser lo que se ejecuta en el if anterior
//    _level1.instruccion=_global.nodeBloques.childNodes[bloque-1].childNodes[3].childNodes;
	
	//_level1.estado=_global.nodeBloques.childNodes[bloque-1].childNodes[3].attributes.estado;
	_level0.estatus=bloque+"/"+_global.nrobloques;
}

//Funcion para cargar XML 
_global.cargarxml=function (archivoXML){ 
	_global.Doc = new XML();
	_global.Doc.ignoreWhite = true;
    _global.Doc.load(archivoXML);
}

//*** Conociendo XML De ABC
_global.conocerABC=function(archivoXML){
    cargarxml(archivoXML);
    _global.Doc.onLoad = function() {
 	     _global.nodeDocABC = _global.Doc.childNodes;
		 _global.nodeABC=_global.nodeDocABC[0];    
  	     _level0.nombreABC = _global.nodeABC.childNodes[0].childNodes;
		 _global.estandar = _global.nodeABC.childNodes[2].childNodes;
	};
}
//Fin conocer XML ABC
//
//**************************
//Funcion que lee el XML y asigna en variables globales los valores de los Nodos
_global.cargarOA=function(archivoXML){
	   cargarmiOA(archivoXML);
	   cargarxml(archivoXML);
	   _global.fin=0;
      _global.Doc.onLoad = function() {
   	  _global.nodeDoc = _global.Doc.childNodes;
  	  //Tomando nodo OA	  
	  _global.nodeOA = _global.nodeDoc[0].childNodes;
	  //Tomando nodo ABC 
	  _global.nodeABC=_global.nodeOA[0];    
	  _global.leccion = _global.nodeABC.childNodes[0].childNodes;
	  _global.nombreOA = _global.nodeABC.childNodes[1].childNodes;
	  _global.menusup= _global.nodeABC.childNodes[2].childNodes;
      //Tomando el nodo Bloques	  
      _global.nodeBloques =_global.nodeOA[1];
	  _global.nrobloques =_global.nodeBloques.childNodes.length;  
       mostrarbloque1();
      
	  _level0.estatus=_global.contadorbloque+" de "+_global.nrobloques;
	   
	   datosbloque(_global.contadorbloque);
 };
}//Fin cargar xml
function habilitarbotones(){
  _global.estandar="E"+_global.estandar;
  if(_global.estandar!="Ecd"){
       _level0.menu_mc.gotoAndStop("deshabilitado");
  }
  else{
     _level0.menu_mc.gotoAndStop("habilitado");
    }
	
   _level0.atras_mc.gotoAndStop("deshabilitado");
}
//carga del OA.swf
function cargarmiOA(archivoXML){
   variable="E"+_global.estandar;
   if (variable== "Eaicc") {
        archivo = _level0.OA+".swf"+"?aicc_url="+_level0.AICC_URLl+"&aicc_sid="+_level0.AICC_SID+"&miXML="+archivoXML;						
	} 
	else {
		archivo = _level0.OA+".swf"+"?miXML="+archivoXML;
	}
	unloadMovieNum(1);
	loadMovieNum(archivo, 1);
}
