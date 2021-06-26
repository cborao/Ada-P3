

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Maps_G_Array.adb)


	with Ada.Text_IO;
	with Ada.Strings.Unbounded;

package body Maps_G is

	package ASU renames Ada.Strings.Unbounded;

	procedure Put (M: in out Map;
		       Key: Key_Type;
		       Value: Value_Type) is
	
		Position: Natural := 1;
		Found: Boolean;
	begin	
		Found := False;
		if M.P_Array = null then
			M.P_Array := new Cell_Array;
			M.P_Array(1) := (Key,Value,True);
			M.Length := 1;
			Found := True;
		else
			while not Found and Position <= M.Length loop
				
				if M.P_Array(Position).Key = Key then
					
					M.P_Array(Position).Value := Value;
					Found := True;
				end if;
				Position := Position+1;
			end loop;

			if not Found then
				
				if M.Length >= Max_Clients then
					raise Full_Map;
				end if;
				M.P_Array(Position) := (Key,Value,True);
				M.Length := M.Length + 1;
			end if;
		end if;
	end Put;

	procedure Get (M: Map;
		       Key: in Key_Type;
		       Value: out Value_Type;
		       Success: out Boolean) is

		Position: Natural := 1;
	begin
		if M.P_Array = null then
			Success := False;
		else
			Success := False;
			while not Success and Position <= M.Length loop
	
				if M.P_Array(Position).Key = Key then
					Value := M.P_Array(Position).Value;
					Success := True;
				end if;
				Position := Position + 1;
			end loop;
		end if;
	end Get;

	procedure Delete (M: in out Map;
			  Key: in Key_Type;
			  Success: out Boolean) is

		Position: Natural := 1;
	begin
		Success := False;
		while not Success and Position <= M.Length loop
			if M.P_Array(Position).Key = Key then
				Success := True;
				for I in Position..M.Length-1 loop
					M.P_Array(I) := M.P_Array(I+1);
				end loop;
			end if;
		Position := Position + 1;
		end loop;
		M.Length := M.Length - 1;
	end Delete;

	function Map_Length (M: Map) return Natural is

	begin
		return M.Length;
	end Map_Length;

	function First (M: Map) return Cursor is
		C: Cursor;
	begin
		C.M := M;
		C.Position := 1;
		return C;
	end First;
	
	procedure Next (C: in out Cursor) is

	begin
		C.Position := C.Position + 1;
	end;

	function Has_Element (C: Cursor) return Boolean is
	
	begin
		if C.Position > C.M.Length then
			return False;
		else
			return C.M.P_Array(C.Position).Full;
		end if;
	end Has_Element;

	function Element (C: Cursor) return Element_Type is
		Element: Element_Type;
	begin
		if Has_Element (C) then
			Element.Key := C.M.P_Array(C.Position).Key;
			Element.Value := C.M.P_Array(C.Position).Value;
		else 
			raise No_Element;
		end if;
		return Element;
	end Element;
end Maps_G;
