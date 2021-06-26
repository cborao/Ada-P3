


	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Chat_Procedures.ads)


	with Maps_G;
	with Ada.Text_IO;
	with Ada.Calendar;
	with Lower_Layer_UDP;
	with Ada.Command_Line;
	with Ada.Strings.Unbounded;

package Chat_Procedures is

	package ATI renames Ada.Text_IO;
	package LLU renames Lower_Layer_UDP;
	package ACL renames Ada.Command_Line;
	package ASU renames Ada.Strings.Unbounded;
	
	use type ASU.Unbounded_String;

	type Data is record
		Client_EP: LLU.End_Point_Type;
		Time: Ada.Calendar.Time;
	end record;

		
	function Max_Valid (Max_Clients: Natural) return Boolean;


	package Active_Clients is new Maps_G (Key_Type => ASU.Unbounded_String,
					      Value_Type => Data,
					      Max_Clients => Natural'Value(ACL.Argument(2)),
					      "=" => ASU."=");

	package Old_Clients is new Maps_G (Key_Type => ASU.Unbounded_String,
					   Value_Type => Ada.Calendar.Time,
					   Max_Clients => 150,
					   "=" => ASU."=");

	Active_Map: Active_Clients.Map;
	Old_Map: Old_Clients.Map;

	procedure Print_Active_Map;
	
	procedure Print_Old_Map;

	procedure Case_Init (I_Buffer: access LLU.Buffer_Type;
			     O_Buffer: access LLU.Buffer_Type);

	procedure Case_Writer (I_Buffer: access LLU.Buffer_Type;
			       O_Buffer: access LLU.Buffer_Type);
	
	procedure Case_Logout (I_Buffer: access LLU.Buffer_Type;
			       O_Buffer: access LLU.Buffer_Type);
end Chat_Procedures;
