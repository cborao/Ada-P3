

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Chat_Procedures.adb)


	with Ada.Text_IO;
	with Chat_Messages;
	with Gnat.Calendar.Time_IO;
	with Ada.Strings.Unbounded;

package body Chat_Procedures is

	package CM renames Chat_Messages;

	use type Ada.Calendar.Time;

	function Max_Valid (Max_Clients: Natural) return Boolean is

	begin
		if Max_Clients >= 2 and Max_Clients <= 50 then
			return True;
		else
			return False;
		end if;
	end Max_Valid;

	procedure Send_To_Readers (Automatic: Boolean;
				   Nick: in out ASU.Unbounded_String;
				   Comment: ASU.Unbounded_String;
				   O_Buffer: access LLU.Buffer_Type) is

		C: Active_Clients.Cursor := Active_Clients.First(Active_Map);
		
	begin
		if Automatic then
			Nick := ASU.To_Unbounded_String("server");
		end if;

		while Active_Clients.Has_Element(C) loop

			if Active_Clients.Element(C).Key /= Nick then

				CM.Server_Message (Active_Clients.Element(C).Value.Client_EP,
				Nick,Comment,O_Buffer);
			end if;

			Active_Clients.Next(C);
		end loop;
	end Send_To_Readers;


   	function Time_Image (T: Ada.Calendar.Time) return String is
  	begin
     		return Gnat.Calendar.Time_IO.Image(T, "%d-%b-%y %T.%i");
  	end Time_Image;

	function Format_EP (EP_Image: in out ASU.Unbounded_String) return ASU.Unbounded_String is

		IP_Image:   	ASU.Unbounded_String;
		Port_Image: 	ASU.Unbounded_String;
		Position:   	Integer;
		Delimiter:  	String := " ";
		Result:		ASU.Unbounded_String;
		
	begin
		for I in 1..2 loop
			Position := ASU.Index(EP_Image, Delimiter);
			ASU.Tail(EP_Image, ASU.Length(EP_Image) - Position);
		end loop;

		Position := ASU.Index(EP_Image, Delimiter);
		IP_Image := ASU.Head (EP_Image, Position - 2);
		ASU.Tail(EP_Image, ASU.Length(EP_Image) - Position);

		Position := ASU.Index(EP_Image, Delimiter);
		Port_Image := ASU.Tail(EP_Image, ASU.Length(EP_Image) - Position - 1);
	
		Result := "(" & IP_Image & ":" & Port_Image & ")";
		return Result;
	end Format_EP;

	procedure Print_Active_Map is
		C: Active_Clients.Cursor := Active_Clients.First(Active_Map);
		EP_Image: ASU.Unbounded_String;
	begin
		Ada.Text_IO.Put_Line ("ACTIVE CLIENTS");
		Ada.Text_IO.Put_Line ("==============");

		while Active_Clients.Has_Element(C) loop
			EP_Image := ASU.To_Unbounded_String(LLU.Image(Active_Clients.Element
			(C).Value.Client_EP));

			Ada.Text_IO.Put_Line (ASU.To_String(Active_Clients.Element(C).Key) &
			" " &
			ASU.To_String(Format_EP(EP_Image)) & " " &
			Time_Image(Active_Clients.Element(C).Value.Time));

			Active_Clients.Next(C);
		end loop;
		ATI.New_Line;
	end Print_Active_Map;

	procedure Print_Old_Map is
		C: Old_Clients.Cursor := Old_Clients.First(Old_Map);
	begin
		Ada.Text_IO.Put_Line ("OLD CLIENTS");
		Ada.Text_IO.Put_Line ("===========");

		while Old_Clients.Has_Element(C) loop
			Ada.Text_IO.Put_Line (ASU.To_String(Old_Clients.Element(C).Key) &
			": " & Time_Image(Old_Clients.Element(C).Value));

			Old_Clients.Next(C);
		end loop;
		ATI.New_Line;
	end Print_Old_Map;


	function Client_To_Ban (Active_Map: Active_Clients.Map) return ASU.Unbounded_String is

		C: Active_Clients.Cursor := Active_Clients.First(Active_Map);
		Min_Time: Ada.Calendar.Time;
		Nick: ASU.Unbounded_String;
	begin
		Min_Time := Active_Clients.Element(C).Value.Time;
		Nick :=  Active_Clients.Element(C).Key;
		while Active_Clients.Has_Element(C) loop

			if Active_Clients.Element(C).Value.Time < Min_Time then
	
				Nick := Active_Clients.Element(C).Key;
				
			end if;
			Active_Clients.Next(C);
		end loop;
		return Nick;
	end Client_To_Ban;

	procedure Server_To_All (Comment: ASU.Unbounded_String;
			         O_Buffer: access LLU.Buffer_Type) is
		
		C:    Active_Clients.Cursor := Active_Clients.First(Active_Map);
		Nick: ASU.Unbounded_String := ASU.To_Unbounded_String("Server");
		
	begin
		while Active_Clients.Has_Element(C) loop

			CM.Server_Message (Active_Clients.Element(C).Value.Client_EP,
			Nick,Comment,O_Buffer);
	
			Active_Clients.Next(C);
		end loop;
	end Server_To_All;

	procedure Case_Init (I_Buffer: access LLU.Buffer_Type;
			     O_Buffer: access LLU.Buffer_Type) is
	
		Client_EP_Receive: LLU.End_Point_Type;
		Client_EP_Handler: LLU.End_Point_Type;
		Nick: 		   ASU.Unbounded_String;
		Ban_Nick: 	   ASU.Unbounded_String;
		Comment: 	   ASU.Unbounded_String;
		Logout_Time: 	   Ada.Calendar.Time;
		Client_Data: 	   Data;
		Accepted: 	   Boolean;
		Success: 	   Boolean;
	begin
			
		Client_EP_Receive := LLU.End_Point_Type'Input (I_Buffer);
		Client_EP_Handler := LLU.End_Point_Type'Input (I_Buffer);
		Nick := ASU.Unbounded_String'Input (I_Buffer);
		
		Active_Clients.Get(Active_Map,Nick,Client_Data,Success);

		if Success then 
			Accepted := False;
			ATI.Put_Line("INIT received from " & ASU.To_String(Nick)
			& ": IGNORED. nick already used");
		else
			ATI.Put_Line("INIT received from " & ASU.To_String(Nick)
			& ": ACCEPTED");
			begin
				Accepted := True;
				Client_Data.Client_EP := Client_EP_Handler;
				Client_Data.Time := Ada.Calendar.Clock;
				
				Active_Clients.Put (Active_Map,Nick,Client_Data);

			exception
				when Active_Clients.Full_Map =>
					
					Ban_Nick := Client_To_Ban(Active_Map);
					Logout_Time := Ada.Calendar.Clock;
					
					Old_Clients.Put (Old_Map,Ban_Nick,Logout_Time);
					
					Comment := ASU.To_Unbounded_String(ASU.To_String(Ban_Nick)
					 & " banned for being idle too long");

					Server_To_All (Comment,O_Buffer);

					Active_Clients.Delete (Active_Map,Ban_Nick,Success);

					Active_Clients.Put (Active_Map,Nick,Client_Data);
					
			end;
			
			Comment := ASU.To_Unbounded_String(ASU.To_String(Nick) &
			" joins the chat");

			--Automatic := True
			Send_To_Readers (True,Nick,Comment,O_Buffer);

		end if;

		CM.Welcome_Message(Client_EP_Receive,Accepted,
		O_Buffer);

	end Case_Init;
		

	procedure Case_Writer (I_Buffer: Access LLU.Buffer_Type;
			       O_Buffer: Access LLU.Buffer_Type) is

		Client_EP_Handler: LLU.End_Point_Type;
		Nick: 	     	   ASU.Unbounded_String;
		Comment:	   ASU.Unbounded_String;
		Success:	   Boolean;
		Client_Data:	   Data;
	begin
		
		Client_EP_Handler := LLU.End_Point_Type'Input (I_Buffer);
		Nick := ASU.Unbounded_String'Input (I_Buffer);
		Comment := ASU.Unbounded_String'Input (I_Buffer);

		Active_Clients.Get(Active_Map,Nick,Client_Data,Success);

		if Success and LLU."="(Client_Data.Client_EP,Client_EP_Handler) then

			ATI.Put_Line("WRITER received from " & ASU.To_String(Nick) & ": " &
			ASU.To_String(Comment));
			Client_Data.Time := Ada.Calendar.Clock;

			Active_Clients.Put(Active_Map,Nick,Client_Data);

			--Automatic := False
			Send_To_Readers (False,Nick,Comment,O_Buffer);
		else	
			ATI.Put_Line("WRITER received from unknown client. IGNORED");
		end if;
		
	end Case_Writer;
	
	procedure Case_Logout (I_Buffer: access LLU.Buffer_Type;
			       O_Buffer: access LLU.Buffer_Type) is

		Client_EP_Handler: LLU.End_Point_Type;
		Nick: 		   ASU.Unbounded_String;
		Comment:	   ASU.Unbounded_String;
		Success: 	   Boolean;
		Client_Data:	   Data;

	begin
		Client_EP_Handler := LLU.End_Point_Type'Input (I_Buffer);
		Nick := ASU.Unbounded_String'Input (I_Buffer);

		Active_Clients.Get(Active_Map,Nick,Client_Data,Success);

		if Success and LLU."="(Client_Data.Client_EP,Client_EP_Handler) then

			ATI.Put_Line("LOGOUT received from " & ASU.To_String(Nick));
			Active_Clients.Delete (Active_Map,Nick,Success);
			Client_Data.Time := Ada.Calendar.Clock;
			Old_Clients.Put (Old_Map,Nick,Client_Data.Time);

			Comment := ASU.To_Unbounded_String(ASU.To_String(Nick) &
			" leaves the chat");

			--Automatic := True 
			Send_To_Readers (True,Nick,Comment,O_Buffer);
		
		else
			ATI.Put_Line("LOGOUT received from banned " & ASU.To_String(Nick));
		end if;
	end Case_Logout;

end Chat_Procedures;
