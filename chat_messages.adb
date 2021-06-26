

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Chat_Messages.adb)


	with Ada.Text_IO;
	with Lower_Layer_UDP;
	with Ada.Strings.Unbounded;

package body Chat_Messages is
	
	package ATI renames Ada.Text_IO;
	use Ada.Strings.Unbounded;


	procedure Init_Message (Server_EP: LLU.End_Point_Type;
				Client_EP_Receive: LLU.End_Point_Type;
				Client_EP_Handler: LLU.End_Point_Type;
				Nick: ASU.Unbounded_String;
			        O_Buffer: Access LLU.Buffer_Type) is

	begin
		Message_Type'Output(O_Buffer, Init);	
		LLU.End_Point_Type'Output(O_Buffer, Client_EP_Receive);
		LLU.End_Point_Type'Output(O_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(O_Buffer, Nick);
		LLU.Send(Server_EP, O_Buffer);
		LLU.Reset(O_Buffer.all);

	end Init_Message;

	procedure Welcome_Message (Client_EP_Handler: LLU.End_Point_Type;
				   Accepted: Boolean;
				   O_Buffer: Access LLU.Buffer_Type) is
	
	begin
		Message_Type'Output(O_Buffer, Welcome);
		Boolean'Output(O_Buffer, Accepted);
		LLU.Send (Client_EP_Handler, O_Buffer);
		LLU.Reset (O_Buffer.all);
	end Welcome_Message;

	procedure Server_Message (Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  Comment: ASU.Unbounded_String;
			  	  O_Buffer: Access LLU.Buffer_Type) is

	begin

		Message_Type'Output (O_Buffer,Server);
		ASU.Unbounded_String'Output (O_Buffer,Nick);
		ASU.Unbounded_String'Output (O_Buffer,Comment);
		
		LLU.Send(Client_EP_Handler, O_Buffer);
		LLU.Reset (O_Buffer.all);

	end Server_Message;

	procedure Writer_Message (Server_EP: LLU.End_Point_Type;
				  Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  Comment: ASU.Unbounded_String;
				  O_Buffer: Access LLU.Buffer_Type) is

	begin

		Message_Type'Output(O_Buffer, Writer);
		LLU.End_Point_Type'Output(O_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(O_Buffer, Nick);
		ASU.Unbounded_String'Output(O_Buffer, Comment);

		LLU.Send(Server_EP, O_Buffer);
		LLU.Reset(O_Buffer.all);
	end Writer_Message;

	procedure Logout_Message (Server_EP: LLU.End_Point_Type;
				  Client_EP_Handler: LLU.End_Point_Type;
				  Nick: ASU.Unbounded_String;
				  O_Buffer: Access LLU.Buffer_Type) is
	begin

		Message_Type'Output(O_Buffer, Logout);
		LLU.End_Point_Type'Output(O_Buffer, Client_EP_Handler);
		ASU.Unbounded_String'Output(O_Buffer, Nick);
		LLU.Send(Server_EP, O_Buffer);
		LLU.Reset(O_Buffer.all);

	end Logout_Message;

end Chat_Messages;
