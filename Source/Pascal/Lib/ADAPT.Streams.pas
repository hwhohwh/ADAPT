{
  AD.A.P.T. Library
  Copyright (C) 2014-2018, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Streams;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils, System.RTLConsts,
    {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF MSWINDOWS}
    {$IFDEF POSIX}Posix.UniStd,{$ENDIF POSIX}
  {$ELSE}
    Classes, SysUtils, RTLConsts,
    {$IFDEF MSWINDOWS}Windows,{$ENDIF MSWINDOWS}
    {$IFDEF POSIX}Posix,{$ENDIF POSIX}
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf,
  ADAPT.Comparers.Intf,
  ADAPT.Streams.Intf, ADAPT.Streams.Abstract;

  {$I ADAPT_RTTI.inc}

type
  { Forward Declarations }
  TADHandleStreamCaret = class;
  TADHandleStream = class;
  TADFileStreamCaret = class;
  TADFileStream = class;
  TADMemoryStreamCaret = class;
  TADMemoryStream = class;

  ///  <summary><c>Caret specifically set up for Handle Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADHandleStreamCaret = class(TADStreamCaret)
  protected
    FHandle: THandle;
    { IADStreamCaret }
    function GetPosition: Int64; override;
    procedure SetPosition(const APosition: Int64); override;
  public
    constructor Create(const AStream: IADStream; const AHandle: THandle); reintroduce; overload;
    constructor Create(const AStream: IADStream; const AHandle: THandle; const APosition: Int64); reintroduce; overload;
    { IADStreamCaret }
    function Delete(const ALength: Int64): Int64; override;
    function Insert(const ABuffer; const ALength: Int64): Int64; override;
    function Read(var ABuffer; const ALength: Int64): Int64; override;
    function Write(const ABuffer; const ALength: Int64): Int64; override;
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64; override;
  end;

  ///  <summary><c>Specialized Stream Type for Handle Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADHandleStream = class(TADStream)
  protected
    FHandle: THandle;
    { IADStream }
    function GetSize: Int64; override;
    procedure SetSize(const ASize: Int64); override;
    { Internal Methods }
    function MakeNewCaret: IADStreamCaret; override;
  public
    constructor Create(const AHandle: THandle); reintroduce; overload;
    constructor Create(const AStream: THandleStream); reintroduce; overload;
    { IADStream }
    procedure LoadFromFile(const AFileName: String); override;
    procedure LoadFromStream(const AStream: IADStream); overload; override;
    procedure LoadFromStream(const AStream: TStream); overload; override;

    procedure SaveToFile(const AFileName: String); override;
    procedure SaveToStream(const AStream: IADStream); overload; override;
    procedure SaveToStream(const AStream: TStream); overload; override;
  end;

  ///  <summary><c>Caret specifically set up for File Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADFileStreamCaret = class(TADHandleStreamCaret); // Nothing needs overriding here... isn't that beautiful?

  ///  <summary><c>Specialized Stream Type for File Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADFileStream = class(TADHandleStream)
  private
    FAdoptedHandle: Boolean;
    FFileName: String;
  protected
    { Internal Methods }
    function MakeNewCaret: IADStreamCaret; override;
  public
    constructor Create(const AFileName: String; const AMode: Word); reintroduce; overload;
    constructor Create(const AFileName: String; const AMode: Word; const ARights: Cardinal); reintroduce; overload;
    constructor Create(const AStream: TFileStream); reintroduce; overload;
    destructor Destroy; override;
  end;

  ///  <summary><c>Caret specifically set up for Memory Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADMemoryStreamCaret = class(TADStreamCaret)
  private
    FMemory: Pointer;
  protected
    function GetMemoryStream: IADMemoryStream;
    { IADStreamCaret }
    function GetPosition: Int64; override;
    procedure SetPosition(const APosition: Int64); override;
  public
    { IADStreamCaret }
    function Delete(const ALength: Int64): Int64; override;
    function Insert(const ABuffer; const ALength: Int64): Int64; override;
    function Read(var ABuffer; const ALength: Int64): Int64; override;
    function Write(const ABuffer; const ALength: Int64): Int64; override;
    function Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64; override;
  end;

  ///  <summary><c>Specialized Stream Type for Memory Streams.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADMemoryStream = class(TADStream, IADMemoryStream)
  private
    FCapacity: Int64;
    FMemory: Pointer;
    FSize: Int64;
    procedure SetPointer(const APointer: Pointer; const ASize: Int64);
  protected
    { IADMemoryStream }
    function GetCapacity: Int64; virtual;
    procedure SetCapacity(ACapacity: Int64); virtual;
    function Realloc(var ACapacity: Int64): Pointer; virtual;
    { IADStream }
    function GetSize: Int64; override;
    procedure SetSize(const ASize: Int64); override;
    { Internal Methods }
    function MakeNewCaret: IADStreamCaret; override;
  public
    constructor Create; overload; override;
    constructor Create(const AStream: TCustomMemoryStream); reintroduce; overload;
    destructor Destroy; override;

    procedure LoadFromFile(const AFileName: String); override;
    procedure LoadFromStream(const AStream: IADStream); overload; override;
    procedure LoadFromStream(const AStream: TStream); overload; override;

    procedure SaveToFile(const AFileName: String); override;
    procedure SaveToStream(const AStream: IADStream); overload; override;
    procedure SaveToStream(const AStream: TStream); overload; override;
  end;

function ADStreamCaretComparer: IADComparer<IADStreamCaret>;

implementation

uses
  ADAPT.Comparers;

  {$I ADAPT_RTTI.inc}

var
  GStreamCaretComparer: IADComparer<IADStreamCaret>;

function ADStreamCaretComparer: IADComparer<IADStreamCaret>;
begin
  Result := GStreamCaretComparer;
end;

{ TADHandleStreamCaret }

constructor TADHandleStreamCaret.Create(const AStream: IADStream; const AHandle: THandle);
begin
  inherited Create(AStream);
  FHandle := AHandle;
end;

constructor TADHandleStreamCaret.Create(const AStream: IADStream; const AHandle: THandle; const APosition: Int64);
begin
  Create(AStream, AHandle);
  SetPosition(APosition);
end;

function TADHandleStreamCaret.Delete(const ALength: Int64): Int64;
var
  LStartPosition, LSize: Int64;
  LValue: TBytes;
begin
  inherited;
  LStartPosition := Position;
  LSize := GetStream.Size;
  if GetStream.Size > Position + ALength then
  begin
    SetLength(LValue, LSize - ALength);
    Position := Position + ALength;
    Read(LValue[0], LSize - ALength);
    Position := LStartPosition;
    Write(LValue[0], ALength);
  end;
  GetStream.Size := LSize - ALength;
  // Invalidate the Carets representing the Bytes we've deleted
  GetStreamManagement.InvalidateCarets(LStartPosition, ALength);
  // Shift subsequent Carets to the left
  GetStreamManagement.ShiftCaretsLeft(LStartPosition + ALength, LSize - (LStartPosition + ALength));
  if LStartPosition < GetStream.Size then // If this Caret is still in range...
    Position := LStartPosition // ...set this Caret's position back to where it began
  else // otherwise, if this Caret is NOT in range...
    Invalidate; // ...invalidate this Caret
  Result := ALength;
end;

function TADHandleStreamCaret.GetPosition: Int64;
begin
  Result := FPosition;
end;

function TADHandleStreamCaret.Insert(const ABuffer; const ALength: Int64): Int64;
var
  I, LStartPosition, LNewSize: Int64;
  LByte: Byte;
begin
  Result := inherited;
  LStartPosition := FPosition;
  // Expand the Stream
  LNewSize := GetStream.Size + ALength;
  GetStream.Size := LNewSize;
  // Move subsequent Bytes to the Right
  I := LStartPosition;
  repeat
    Seek(I, soBeginning); // Navigate to the Byte
    Read(LByte, 1); // Read this byte
    Seek(I + ALength + 1, soBeginning); // Navigate to this Byte's new location
    Write(LByte, 1); // Write this byte
    Inc(I); // On to the next
    Inc(Result);
  until I > LNewSize;
  // Insert the Value
  Position := LStartPosition;
  Write(ABuffer, ALength);
  // Shift overlapping Carets to the Right
  GetStreamManagement.ShiftCaretsRight(LStartPosition, ALength);
  Position := LStartPosition + ALength;
end;

function TADHandleStreamCaret.Read(var ABuffer; const ALength: Int64): Int64;
begin
  inherited;
  Seek(FPosition, soBeginning);
  Result := FileRead(FHandle, ABuffer, ALength);
  if Result = -1 then
    Result := 0
  else
    Inc(FPosition, ALength);
end;

function TADHandleStreamCaret.Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64;
begin
  inherited;
  Result := FileSeek(FHandle, AOffset, Ord(AOrigin));
end;

procedure TADHandleStreamCaret.SetPosition(const APosition: Int64);
begin
  FPosition := APosition;
end;

function TADHandleStreamCaret.Write(const ABuffer; const ALength: Int64): Int64;
var
  LStartPosition: Int64;
begin
  inherited;
  LStartPosition := FPosition;
  Seek(FPosition, soBeginning);
  Result := FileWrite(FHandle, ABuffer, ALength);
  if Result = -1 then
    Result := 0
  else begin
    Inc(FPosition, ALength);
    GetStreamManagement.InvalidateCarets(LStartPosition, ALength);
  end;
end;

{ TADHandleStream }

constructor TADHandleStream.Create(const AHandle: THandle);
begin
  FHandle := AHandle;
  inherited Create;
end;

constructor TADHandleStream.Create(const AStream: THandleStream);
begin
  Create(AStream.Handle);
end;

function TADHandleStream.GetSize: Int64;
var
  LPos: Int64;
begin
  LPos := FileSeek(FHandle, 0, Ord(soCurrent));
  Result := FileSeek(FHandle, 0, Ord(soEnd));
  FileSeek(FHandle, LPos, Ord(soBeginning));
end;

procedure TADHandleStream.LoadFromFile(const AFileName: String);
var
  LStream: IADStream;
begin
  LStream := TADFileStream.Create(AFileName, fmOpenRead);
  LoadFromStream(LStream);
end;

procedure TADHandleStream.LoadFromStream(const AStream: TStream);
var
  LWriteCaret: IADStreamCaret;
  I: Int64;
  LValue: Byte;
begin
  AStream.Position := 0;
  Size := AStream.Size;
  LWriteCaret := NewCaret;
  I := 0;
  repeat
    AStream.Read(LValue, 1);
    LWriteCaret.Write(LValue, 1);
  until I > AStream.Size;
end;

procedure TADHandleStream.LoadFromStream(const AStream: IADStream);
var
  LReadCaret, LWriteCaret: IADStreamCaret;
  I: Int64;
  LValue: Byte;
begin
  Size := AStream.Size;
  LReadCaret := AStream.NewCaret;
  LWriteCaret := NewCaret;
  I := 0;
  repeat
    LReadCaret.Read(LValue, 1);
    LWriteCaret.Write(LValue, 1);
    Inc(I);
  until I > AStream.Size;
end;

function TADHandleStream.MakeNewCaret: IADStreamCaret;
begin
  Result := TADHandleStreamCaret.Create(Self, FHandle);
end;

procedure TADHandleStream.SaveToFile(const AFileName: String);
var
  LStream: IADStream;
begin
  LStream := TADFileStream.Create(AFileName, fmCreate);
  SaveToStream(LStream);
end;

procedure TADHandleStream.SaveToStream(const AStream: TStream);
var
  LReadCaret: IADStreamCaret;
  I: Int64;
  LValue: Byte;
begin
  AStream.Size := 0;
  I := 0;
  repeat
    LReadCaret.Read(LValue, 1);
    AStream.Write(LValue, 1);
    Inc(I);
  until I > Size;
end;

procedure TADHandleStream.SaveToStream(const AStream: IADStream);
var
  LReadCaret, LWriteCaret: IADStreamCaret;
  I: Int64;
  LValue: Byte;
begin
  AStream.Size := 0;
  LReadCaret := NewCaret;
  LWriteCaret := AStream.NewCaret;
  I := 0;
  repeat
    LReadCaret.Read(LValue, 1);
    LWriteCaret.Write(LValue, 1);
    Inc(I);
  until I > Size;
end;

procedure TADHandleStream.SetSize(const ASize: Int64);
var
  {$IFDEF POSIX}LPosition,{$ENDIF POSIX} LOldSize: Int64;
begin
  LOldSize := GetSize;
  {$IFDEF POSIX}LPosition := {$ENDIF POSIX}FileSeek(FHandle, ASize, Ord(soBeginning));
  {$WARNINGS OFF} // We're handling platform-specifics here... we don't NEED platform warnings!
  {$IF Defined(MSWINDOWS)}
    Win32Check(SetEndOfFile(FHandle));
  {$ELSEIF Defined(POSIX)}
    if ftruncate(FHandle, LPosition) = -1 then
      raise EStreamError(sStreamSetSize);
  {$ELSE}
    {$FATAL 'No implementation for this platform! Please report this issue on https://github.com/LaKraven/LKSL'}
  {$ENDIF}
  {$WARNINGS ON}
  if ASize < LOldSize then
    InvalidateCarets(LOldSize, ASize - LOldSize);
end;

{ TADFileStream }

constructor TADFileStream.Create(const AFileName: String; const AMode: Word);
begin
  Create(AFilename, AMode, 0);
end;

constructor TADFileStream.Create(const AFileName: String; const AMode: Word; const ARights: Cardinal);
var
  LShareMode: Word;
begin
  FAdoptedHandle := False;
  if (AMode and fmCreate = fmCreate) then
  begin
    LShareMode := AMode and $FF;
    if LShareMode = $FF then
      LShareMode := fmShareExclusive;
    inherited Create(FileCreate(AFileName, LShareMode, ARights));
    if FHandle = INVALID_HANDLE_VALUE then
      raise EFCreateError.CreateResFmt(@SFCreateErrorEx, [ExpandFileName(AFileName), SysErrorMessage(GetLastError)]);
  end
  else
  begin
    inherited Create(FileOpen(AFileName, AMode));
    if FHandle = INVALID_HANDLE_VALUE then
      raise EFOpenError.CreateResFmt(@SFOpenErrorEx, [ExpandFileName(AFileName), SysErrorMessage(GetLastError)]);
  end;
  FFileName := AFileName;
end;

constructor TADFileStream.Create(const AStream: TFileStream);
begin
  inherited Create(AStream.Handle);
  FAdoptedHandle := True;
end;

destructor TADFileStream.Destroy;
begin
  if (FHandle <> INVALID_HANDLE_VALUE) and (not FAdoptedHandle) then
    FileClose(FHandle);
  inherited;
end;

function TADFileStream.MakeNewCaret: IADStreamCaret;
begin
  Result := TADFileStreamCaret.Create(Self, FHandle);
end;

{ TADMemoryStreamCaret }

function TADMemoryStreamCaret.Delete(const ALength: Int64): Int64;
begin
  // Shift elements after Position + Length back to Position
  if FPosition + ALength < GetStream.Size then
    System.Move(
                  (PByte(FMemory) + FPosition + ALength)^,
                  (PByte(FMemory) + FPosition)^,
                  GetStream.Size - (FPosition + ALength)
               );
  // Dealloc Memory
  GetStream.Size := GetStream.Size - ALength;
  // Invalidate the Carets representing the Bytes we've deleted
  GetStreamManagement.InvalidateCarets(FPosition, ALength);
  // Shift subsequent Carets to the left
  GetStreamManagement.ShiftCaretsLeft(FPosition + ALength, ALength - (FPosition + ALength));
  Result := ALength;
end;

function TADMemoryStreamCaret.GetMemoryStream: IADMemoryStream;
begin
  Result := GetStream as IADMemoryStream;
end;

function TADMemoryStreamCaret.GetPosition: Int64;
begin
  Result := FPosition;
end;

function TADMemoryStreamCaret.Insert(const ABuffer; const ALength: Int64): Int64;
var
  LStartPosition: Int64;
begin
  LStartPosition := FPosition;
  GetStream.Size := GetStream.Size + ALength;
  // Shift subsequent Bytes to the Right
  System.Move(
                (PByte(FMemory) + FPosition)^,
                (PByte(FMemory) + FPosition + ALength)^,
                GetStream.Size - (FPosition + ALength)
             );
  // Write the Data
  Write(ABuffer, ALength);
  // Shift subsequent Carets to the Right
  GetStreamManagement.ShiftCaretsRight(LStartPosition, (GetStream.Size - ALength) - LStartPosition);
  Result := ALength;
end;

function TADMemoryStreamCaret.Read(var ABuffer; const ALength: Int64): Int64;
begin
  Result := 0;
  if (FPosition < 0) or (ALength < 0) then
    Exit;

  Result := GetStream.Size - FPosition;
  if Result > 0 then
  begin
    if Result > ALength then Result := ALength;
    System.Move((PByte(FMemory) + FPosition)^, ABuffer, Result);
    Inc(FPosition, Result);
  end;
end;

function TADMemoryStreamCaret.Seek(const AOffset: Int64; const AOrigin: TSeekOrigin): Int64;
begin
  case AOrigin of
    soBeginning: Result := AOffset;
    soCurrent: Result := FPosition + AOffset;
    soEnd: Result := GetStream.Size - AOffset;
  else
    Result := FPosition;
  end;
  FPosition := Result;
end;

procedure TADMemoryStreamCaret.SetPosition(const APosition: Int64);
begin
  FPosition := APosition;
end;

function TADMemoryStreamCaret.Write(const ABuffer; const ALength: Int64): Int64;
var
  LPos: Int64;
begin
  Result := 0;
  LPos := FPosition + ALength;

  if (FPosition < 0) or (ALength < 0) or (LPos <= 0) then
    Exit;

  if LPos > GetStream.Size then
  begin
    if LPos > GetMemoryStream.Capacity then
      GetMemoryStream.Capacity := LPos;
    GetStream.Size := LPos;
  end;
  System.Move(ABuffer, (PByte(FMemory) + FPosition)^, ALength);
  FPosition := LPos;
  Result := ALength;
end;

{ TADMemoryStream }

constructor TADMemoryStream.Create;
begin
  inherited;
  SetCapacity(0);
  FSize := 0;
end;

constructor TADMemoryStream.Create(const AStream: TCustomMemoryStream);
begin
  Create;
  FMemory := AStream.Memory;
end;

destructor TADMemoryStream.Destroy;
begin
  SetCapacity(0);
  FSize := 0;
  inherited;
end;

function TADMemoryStream.GetCapacity: Int64;
begin
  Result := FCapacity;
end;

function TADMemoryStream.GetSize: Int64;
begin
  Result := FSize;
end;

procedure TADMemoryStream.LoadFromFile(const AFileName: String);
var
  LStream: IADStream;
begin
  LStream := TADFileStream.Create(AFileName, fmOpenRead);
  LoadFromStream(LStream);
end;

procedure TADMemoryStream.LoadFromStream(const AStream: TStream);
begin
  AStream.Position := 0;
  Size := AStream.Size;
  AStream.Read(FMemory^, AStream.Size);
end;

procedure TADMemoryStream.LoadFromStream(const AStream: IADStream);
var
  LReadCaret: IADStreamCaret;
begin
  Size := AStream.Size;
  LReadCaret := AStream.NewCaret;
  LReadCaret.Read(FMemory^, AStream.Size);
end;

function TADMemoryStream.MakeNewCaret: IADStreamCaret;
begin
  Result := TADMemoryStreamCaret.Create(Self);
end;

function TADMemoryStream.Realloc(var ACapacity: Int64): Pointer;
const
  MemoryDelta = $2000;
begin
  Result := nil;
  if (ACapacity > 0) and (ACapacity <> GetSize) then
    ACapacity := (ACapacity + (MemoryDelta - 1)) and not (MemoryDelta - 1);
  Result := FMemory;
  if ACapacity <> FCapacity then
  begin
    if ACapacity = 0 then
    begin
      FreeMem(FMemory);
      Result := nil;
    end else
    begin
      if FCapacity = 0 then
        GetMem(Result, ACapacity)
      else
        ReallocMem(Result, ACapacity);
      if Result = nil then raise EStreamError.CreateRes(@SMemoryStreamError);
    end;
  end;
end;

procedure TADMemoryStream.SaveToFile(const AFileName: String);
var
  LStream: IADStream;
begin
  LStream := TADFileStream.Create(AFileName, fmCreate);
  SaveToStream(LStream);
end;

procedure TADMemoryStream.SaveToStream(const AStream: TStream);
begin
  if FSize > 0 then
    AStream.WriteBuffer(FMemory^, FSize);
end;

procedure TADMemoryStream.SaveToStream(const AStream: IADStream);
var
  LCaret: IADStreamCaret;
begin
  if FSize > 0 then
  begin
    LCaret := AStream.NewCaret;
    LCaret.Write(FMemory^, FSize);
  end;
end;

procedure TADMemoryStream.SetCapacity(ACapacity: Int64);
begin
  SetPointer(Realloc(ACapacity), FSize);
  FCapacity := ACapacity;
end;

procedure TADMemoryStream.SetPointer(const APointer: Pointer; const ASize: Int64);
begin
  FMemory := APointer;
  FSize := ASize;
end;

procedure TADMemoryStream.SetSize(const ASize: Int64);
var
  LOldSize: Longint;
begin
  LOldSize := FSize;
  SetCapacity(ASize);
  FSize := ASize;
  if ASize < LOldSize then
    InvalidateCarets(LOldSize, ASize - LOldSize);
end;

initialization
  GStreamCaretComparer := TADInterfaceComparer<IADStreamCaret>.Create;

end.
