

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Chat_Messages.ads)


	with Lower_Layer_UDP;
	with Ada.Strings.Unbounded;

package Chat_Messages is
		
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;

	
   	type Message_Type is (Init, Welcome, Writer, Server, Logout);

	procedure Init_Message (Server_EP: LLU.End_Point_Type;
				Client_EP_Receive: LLU.End_Point_Type;
				Client_EP_Handler: LLU.End_Point_Type;
				Nick: ASU.Unbounded_String;
			        O_Buffer: Access LLU.Buffer_Type);
	
	procedure Welcome_Message (Client_EP_Handler: LLU.End_Point_Type;
				   Accepted: Boolean;
				   O_Buffer: Access LLU.Buffer_Type);

	procedure Server_Message (Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  Comment: ASU.Unbounded_String;
				  O_Buffer: Access LLU.Buffer_Type);

	procedure Writer_Message (Server_EP: LLU.End_Point_Type;
				  Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  Comment: ASU.Unbounded_String;
				  O_Buffer: Access LLU.Buffer_Type);

	procedure Logout_Message (Server_EP: LLU.End_Point_Type;
				  Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  O_Buffer: Access LLU.Buffer_Type);

end Chat_Messages;
