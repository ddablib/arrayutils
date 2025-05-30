{
 * Example code for TArrayUtils.Every<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Every;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Every_Eg1;
var
  A, B: TArray<Integer>;
  Constraint: TArrayUtils.TConstraint<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5, 3);
  B := TArray<Integer>.Create(4, 5, 6);
  Constraint := function (const AElem: Integer): Boolean
    begin
      Result := AElem >= 4;
    end;
  Assert(TArrayUtils.Every<Integer>(A, Constraint) = False);
  Assert(TArrayUtils.Every<Integer>(B, Constraint) = True);
end;

procedure Every_Eg2;
var
  Constraint: TArrayUtils.TConstraintEx<Integer>;
  A, B, C: TArray<Integer>;
begin
  Constraint := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      Distance: Integer;
    begin
      // True iff distance betwent element and prior element <=1
      // Assume that single element arrays meet the criteria
      if Length(A) = 1 then
        Exit(True);
      Assert(A[AIndex] = AElem);
      if AIndex = 0 then
        Exit(True);
      Distance := Abs(A[AIndex] - A[AIndex - 1]);
      Result := Distance <= 1;
    end;

  A := TArray<Integer>.Create(0, 1, 0, 1, 2, 1, 2, 1, 0);
  B := TArray<Integer>.Create(0, 1, 2, 0, 1, 2);
  C := TArray<Integer>.Create(42);
  Assert(TArrayUtils.Every<Integer>(A, Constraint) = True);
  Assert(TArrayUtils.Every<Integer>(B, Constraint) = False);
  Assert(TArrayUtils.Every<Integer>(C, Constraint) = True);
end;

initialization

TRegistrar.Add(
  'Every<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Every_Eg1', @Every_Eg1),
    TProcedureInfo.Create('Every_Eg2', @Every_Eg2)
  )
);

end.
