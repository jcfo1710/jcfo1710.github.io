//rutinasLMS.as file..............
// Este documento contiene todas las rutinas necesarias para el 
//paso de valores al LMS
// Las funciones que se encontraran son las siguientes:
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
	tiempototal = int(getTimer() /1000);
    tiem= formatoTiempo(tiempototal);
	return tiempototal;
}

_global.funciones_LMS=function(){
		var variable: String;
		var tipoE: String;
		var url:String;
		var Lstatus:String;
		var tiempo=calcularTiempo();
		//var Lstatus: String;
		//var Score: String;
		//tipode Examen
		var str1:String = _level1.es;
        var tipoE: String = "t"+str1;
		//estandar del ABC
		var variable: String = "E"+_level0.LMS;
		
		if(variable == "Eaicc"){
			
		    if ((int(_global.contadorbloque) < int(_global.nrobloques)) or (_global.llegoalfinal == false)) {
			   Lstatus = "I";
		     } 
		    else {
			   Lstatus = "C";
			}
			
		   if ((((_level0.AICC_URL<>undefined) and (_level0.AICC_SID<>undefined))or (_level1.AICC_URL<>undefined) and (_level1.AICC_SID<>undefined))and(_level0.final == 1)) {
			   _level0.ruta = _level0.AICC_URL;
				//datos a LMS en aicc en caso de que sea un examen
			    if (tipoE == "texamen") {
					_level1.es=_level0.puntaje;
					Score=_level1.es;
				    url = 'guardar.htm?LStatus='+Lstatus+'&score='+Score+'&time='+tiempo+'&aicc_url='+_level0.AICC_URL+'&session_id='+_level0.AICC_SID;
				 }
				 else{
					url = 'guardar.htm?LStatus='+Lstatus+'&time='+tiempo+'&aicc_url='+_level0.AICC_URL+'&session_id='+_level0.AICC_SID;
			      }
				   fscommand("IraPagina", url);
		   }//fin if ((aicc_url<>"") and (aicc_sid<>"")) 
	    }//fin si variable == aicc
	   else{
		 if(variable == "Escorm"){  
		   /* if((_global.llegoalfinal == true)and(_global.fin==0)){
			   _level0.puntaje=100;
			}
			else*/
			   if (!(tipoE == "texamen")){   
				 _level0.puntaje=int((int((_global.contadorbloque))*100)/int(_global.nrobloques));
	             //_level0.puntos =_level0.puntaje;
			    if(_level0.puntaje == 100){
                    //_level0.puntos ="saco 100";
		            Lstatus = "completed";
    		        fscommand ("LMSSetValue","cmi.core.lesson_status,"+Lstatus);
	            }
                else{
		           _level0.puntos ="saco menos de 100";
		            Lstatus = "incompleted";
		            fscommand ("LMSSetValue","cmi.core.lesson_status,"+Lstatus);
  	             }
			   }
			   else{
			    if (tipoE == "texamen") {
  		            fscommand ("LMSSetValue","cmi.core.score.raw,"+_level0.puntaje);
					if(_global.llegoalfinal == false){
						Lstatus = "incompleted";
						fscommand ("LMSSetValue","cmi.core.lesson_status,"+Lstatus);
                    }
					else{
						 Lstatus = "completed";
		                 fscommand ("LMSSetValue","cmi.core.lesson_status,"+Lstatus);
					}
					
  	               if((_level0.puntaje>=parseInt(_global.final[0])) or((_level0.puntaje<parseInt(_global.final[0])) and (_level0.puntaje>=parseInt(_global.final[1])))){
               		   fscommand ("LMSSetValue","cmi.core.lesson_status,passed");
	               }
 	               else{
					  fscommand ("LMSSetValue","cmi.core.lesson_status,failed");
	               }
			    }
			  }
			fscommand ("LMSSetValue","cmi.student_data.time_limit_action," + tiempo);
			commitLMS();
		 }
			
	} 
	if(_global.fin==1){
  	  getURL("javascript:this.close()");
	}

};