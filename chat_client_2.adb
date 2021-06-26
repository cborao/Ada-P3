

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Chat_Client_2)


	with Handlers;
	with Ada.Text_IO;
	with Chat_Messages;
	with Lower_Layer_UDP;
	with Ada.Command_Line;
	with Ada.Strings.Unbounded;

procedure Chat_Client_2 is

	package ATI renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package LLU renames Lower_Layer_UDP;
	package ACL renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;
	
	use type CM.Message_Type;

	Server_EP:  	    LLU.End_Point_Type;
	Port: 	  	    Integer;
	Nick:	   	    ASU.Unbounded_String;
  	Client_EP_Receive:  LLU.End_Point_Type;
	Client_EP_Handler:  LLU.End_Point_Type;
	Buffer_In:    	    aliased LLU.Buffer_Type(1024);
	Buffer_Out:    	    aliased LLU.Buffer_Type(1024);
	Mess:	    	    CM.Message_Type;
	Expired:    	    Boolean;
	Accepted:	    Boolean;
	Comment:    	    ASU.Unbounded_String;

begin

	--Binding
	Port := Integer'Value(ACL.Argument(2));
   	Server_EP := LLU.Build(LLU.To_IP(ACL.Argument(1)),Port);
	Nick := ASU.To_Unbounded_String(ACL.Argument(3));
	LLU.Bind_Any(Client_EP_Receive);
	LLU.Bind_Any(Client_EP_Handler, Handlers.Client_Handler'Access);

	LLU.Reset(Buffer_In);

	if ACL.Argument_Count = 3 then
		if ASU.To_String(Nick) /= "server" then
			--Init Message
			CM.Init_Message(Server_EP,Client_EP_Receive,
					Client_EP_Handler,Nick,Buffer_Out'Access);

			LLU.Receive(Client_EP_Receive, Buffer_In'Access, 10.0, Expired);
		
			if Expired then
				ATI.Put_Line("Server unreachable");
			else
				--Server Reply
				Mess := CM.Message_Type'Input(Buffer_In'Access);
				Accepted := Boolean'Input(Buffer_In'Access);
				LLU.Reset(Buffer_In);

				if Accepted then
	
					ATI.Put_Line("Mini-Chat v2.0: Welcome "
					& ASU.To_String(Nick));
					loop
						ATI.Put(">> ");
						Comment := ASU.To_Unbounded_String(ATI.Get_Line);
						exit when ASU.To_String(Comment) = ".quit";

						--Writer Message
						CM.Writer_Message(Server_EP,Client_EP_Handler,
					 			  Nick,Comment,Buffer_Out'Access);

					end loop;

					--Logout Message
					CM.Logout_Message(Server_EP,Client_EP_Handler,
							  Nick,Buffer_Out'Access);
				else	
					ATI.Put_Line("Mini-Chat v2.0: IGNORED new user " &
					ASU.To_String(Nick) & ", nick already used");
				end if;

			end if;
		else
			ATI.New_Line;
			ATI.Put_Line("Nick 'server' not avaliable, try again");
			ATI.New_Line;
		end if;	
			
	else
		ATI.New_Line;
		ATI.Put_Line("Client Usage: [user] [Port] <nick>");
		ATI.New_Line;
	end if;
	LLU.Finalize;
end Chat_Client_2;
