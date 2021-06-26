

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Handlers.ads)


	with Ada.Calendar;
	with Lower_Layer_UDP;

package Handlers is

	package LLU renames Lower_Layer_UDP;

	procedure Client_Handler (From: in LLU.End_Point_Type;
				  To: in LLU.End_Point_Type;
				  P_Buffer: access LLU.Buffer_Type);
	
	procedure Server_Handler (From: in LLU.End_Point_Type;
				  To: in LLU.End_Point_Type;
				  P_Buffer: access LLU.Buffer_Type);

end Handlers;
