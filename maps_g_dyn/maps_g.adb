

	--PRÁCTICA 3: CÉSAR BORAO MORATINOS (Maps_G_Dyn.adb)


	with Ada.Text_IO;
	with Ada.Strings.Unbounded;

package body Maps_G is

	package ASU renames Ada.Strings.Unbounded;

	procedure Put (M: in out Map;
		       Key: Key_Type;
		       Value: Value_Type) is
	
		P_Aux: Cell_A;
		Success: Boolean;
	begin
		P_Aux := M.P_First;
		Success := False;

		if M.P_First = null then
			M.P_First := new Cell'(Key, Value, null);
			M.Length := 1;
		else
			while not Success and P_Aux.Next /= null loop
				if P_Aux.Key = Key then

					P_Aux.Value := Value;
					Success := True;
				end if;
				P_Aux := P_Aux.Next;
			end loop;

			if not Success and P_Aux.Next = null then

				if P_Aux.Key = Key then

					P_Aux.Value := Value;
					Success := True;
				end if;
			end if;
			if not Success then
			
				if M.Length >= Max_Clients then
					raise Full_Map;
				end if;
				P_Aux.Next := new Cell'(Key, Value, null);
				P_Aux := P_Aux.Next;
				M.Length := M.Length + 1;
			end if;
		end if;
	end Put;

	procedure Get (M: Map;
		       Key: in Key_Type;
		       Value: out Value_Type;
		       Success: out Boolean) is

		P_Aux: Cell_A;
	begin
		P_Aux := M.P_First;
		Success := False;
		while not Success and P_Aux /= null loop
			if P_Aux.Key = Key then
				
				Value := P_Aux.Value;
				Success := True;
			end if;
			P_Aux := P_Aux.Next;
		end loop;
	end Get;

	procedure Delete (M: in out Map;
			  Key: in Key_Type;
			  Success: out Boolean) is

		P_Current: Cell_A;
		P_Previous: Cell_A;

	begin
		Success := False;
		P_Previous := null;
		P_Current := M.P_First;
		while not Success and P_Current /= null loop
			if P_Current.Key = Key then
				Success := True;
				M.Length := M.Length - 1;
				if P_Previous /= null then
					P_Previous.Next:= P_Current.Next;
				end if;
				if M.P_First = P_Current then
					M.P_First := M.P_First.Next;
				end if;
				P_Current := null;
			else
				P_Previous := P_Current;
				P_Current := P_Current.Next;
			end if;
		end loop;
	end Delete;

	function Map_Length (M : Map) return Natural is
	begin
		return M.Length;
	end Map_Length;

	function First (M: Map) return Cursor is
		C: Cursor;
	begin
		C.M := M;
		C.Element_A := M.P_First;

		return C;
	end First;

	procedure Next (C: in out Cursor) is
	begin
		C.Element_A := C.Element_A.Next;
	end Next;

	function Has_Element (C: Cursor) return Boolean is
	begin
		if C.Element_A /= null then
			return True;
		else
			return False;
		end if;
	end Has_Element;

	function Element (C: Cursor) return Element_Type is
		Element: Element_Type;
	begin
		if Has_Element (C) then
			Element.Key := C.Element_A.Key;
			Element.Value := C.Element_A.Value;
		else 
			raise No_Element;
		end if;
		return Element;
	end Element;

end Maps_G;
