

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Handlers.adb)


	with Maps_G;
	with Ada.Text_IO;
	with Chat_Messages;
	with Chat_Procedures;
	with Ada.Strings.Unbounded;

package body Handlers is
	
	package ATI renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CP renames Chat_Procedures;
	package ASU renames Ada.Strings.Unbounded;

	procedure Client_Handler(From: in LLU.End_Point_Type;
				 To: in LLU.End_Point_Type;
				 P_Buffer: access LLU.Buffer_Type) is

	Mess:	  CM.Message_Type;
	Nick:	  ASU.Unbounded_String;
	Comment:  ASU.Unbounded_String;

	begin
		Mess := CM.Message_Type'Input(P_Buffer);
		Nick := ASU.Unbounded_String'Input(P_Buffer);
		Comment := ASU.Unbounded_String'Input(P_Buffer);

		ATI.New_Line;
		ATI.Put_Line(ASU.To_String(Nick) & ": " & ASU.To_String(Comment));
		LLU.Reset(P_Buffer.all);
		ATI.Put(">> ");
		
	end Client_Handler;

	procedure Server_Handler (From: in LLU.End_Point_Type;
				  To: in LLU.End_Point_Type;
				  P_Buffer: access LLU.Buffer_Type) is

		
		Mess: 	    CM.Message_Type;
		Buffer_Out: aliased LLU.Buffer_Type(1024);

	begin
		Mess := CM.Message_Type'Input (P_Buffer);

		case Mess is
			when CM.Init =>
				CP.Case_Init(P_Buffer,Buffer_Out'Access);
			when CM.Writer =>
				CP.Case_Writer(P_Buffer,Buffer_Out'Access);
			when CM.Logout =>
				CP.Case_Logout(P_Buffer,Buffer_Out'Access);	
			when others =>
				ATI.Put_Line("Unknown message type");		
		end case;
		LLU.Reset (P_Buffer.all);
	end Server_Handler;
	
end Handlers;
