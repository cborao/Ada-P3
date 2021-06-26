

		--PRÁCTICA 3: César Borao Moratinos (chat_server_2)

	
	with Handlers;
	with Ada.Text_IO;
	with Ada.Calendar;
	with Chat_Messages;
	with Lower_Layer_UDP;
	with Chat_Procedures;
	with Ada.Command_Line;
	with Ada.Strings.Unbounded;

procedure Chat_Server_2 is

	package ATI renames Ada.Text_IO;
	package CM renames Chat_Messages;
	package CP renames Chat_Procedures;
	package LLU renames Lower_Layer_UDP;
	package ACL renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;
	
	use type CM.Message_Type;
	use type Ada.Calendar.Time;

	Port: 	   Integer; 
	Server_EP: LLU.End_Point_Type;
	Request:   Character;

begin
	--Binding
	Port := Integer'Value(ACL.Argument(1));
	Server_EP := LLU.Build (LLU.To_IP(LLU.Get_Host_Name), Port);
	
	if ACL.Argument_Count = 2 and CP.Max_Valid(Natural'Value(ACL.Argument(2))) then
	
		loop	
			--Server Handler
			LLU.Bind(Server_EP, Handlers.Server_Handler'Access);

			loop
				ATI.Get_Immediate(Request);
				ATI.Put_Line(Character'Image(Request));
				case Request is
					when 'o'|'O' =>
						CP.Print_Old_Map;

					when 'l'|'L' =>
						CP.Print_Active_Map;
					when others =>
						ATI.Put_Line("Not implemented");	
				end case;
			end loop;

		end loop;
	else
		
		ATI.New_Line;
		ATI.Put_Line("Server Usage: [Port] <Max_Clients (2-50)>");
		ATI.New_Line;
		
	end if;
	LLU.finalize;
end Chat_Server_2;
