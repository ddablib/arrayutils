{
 * Example code for TArrayUtils.ForEach<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit ForEach;

interface

implementation

uses
  SysUtils,
  Types,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure ForEach_Eg1;
const
  P1: TPoint = (X: 1; Y: 3);
  P2: TPoint = (X: -1; Y: 5);
  P3: TPoint = (X: 12; Y: -12);
  P4: TPoint = (X: -8; Y: -9);
  P5: TPoint = (X: 12; Y: 5);
var
  A: TArray<TPoint>;
begin
  A := TArray<TPoint>.Create(P1, P2, P3, P4, P5);
  TArrayUtils.ForEach<TPoint>(
    A,
    procedure (const P: TPoint)
    begin
      WriteLn(Format('(%d,%d)', [P.X, P.Y]));
    end
  );
end;

procedure ForEach_Eg2;
var
  A: TArray<Cardinal>;
begin
  A := TArray<Cardinal>.Create(2, 3, 5, 7, 11, 13, 17, 19, 23, 29);
  TArrayUtils.ForEach<Cardinal>(
    A,
    procedure (const AElem: Cardinal; const AIndex: Integer;
      const A: array of Cardinal)
    var
      Distance: Cardinal;
    begin
      // Find distance of AElem to its predecessor in the array
      if AIndex = 0 then
        // no predecessor for 1st element
        Exit;
      Distance := Abs(AElem - A[Pred(AIndex)]);
      if AIndex > 1 then
        Write(', ');
      Write(Distance);
    end
  );
  WriteLn;
end;

initialization

TRegistrar.Add(
  'ForEach<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('ForEach_Eg1', @ForEach_Eg1),
    TProcedureInfo.Create('ForEach_Eg2', @ForEach_Eg2)
  )
);

end.
