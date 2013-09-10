package pl.mardraze 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Logic 
	{
		
		static public const WHITE:String = "white";
		static public const BLACK:String = "black";

		static public const FIGURE_QUEEN:String = "Queen";
		static public const FIGURE_PAWN:String = "Pawn";
		static public const FIGURE_ROOK:String = "Rook";
		static public const FIGURE_KNIGHT:String = "Knight";
		static public const FIGURE_BISHOP:String = "Bishop";
		static public const FIGURE_KING:String = "King";

		private var _positions:Array;
		private var _currentPlayer:String;
		private var _selected:Object;
		private var _pawnOmmitField:Object = {};
		
		public var callGetFigureUpgradePawn:Function;
		public var callHideFigure:Function;
		public var callCloneFigure:Function;
		public var callEndGame:Function;
		public var callMoveFigure:Function;
		
		public function Logic() {
			callGetFigureUpgradePawn = function():String {
				trace('PLEASE ASSIGN CALLBACK Logic.callGetFigureUpgradePawn');
				return FIGURE_QUEEN;
			};
			
			callHideFigure = function(name:String):void {
				trace('PLEASE ASSIGN CALLBACK Logic.callHideFigure');
			};

			callCloneFigure = function(choosenFigureName:String, newFigureName:String, x:int, y:int):void {
				trace('PLEASE ASSIGN CALLBACK Logic.callCloneFigure');
			};
			
			callMoveFigure = function(selectedFigureName:String, x:int, y:int):void {
				trace('PLEASE ASSIGN CALLBACK Logic.callMoveFigure');
			};
			
			callEndGame = function(result:Object):void {
				trace('PLEASE ASSIGN CALLBACK Logic.callEndGame');
			};
			
		}
		
		public function onFieldClick(x:int, y:int):void {
			if (isMyFigure(x, y)) {
				if (!isFrozen(x, y)) {
					var figureName:String = _positions[x][y].figureName;
					_selected = { 
						'x' : x,
						'y' : y,
						'figureName' : figureName,
						'type' : figureName.substr(0, figureName.search('_')),
						'color' : _currentPlayer
					};
				}
			}else {
				move(x, y);
			}
		}
		
		public function start():void {
			_initPositions();
		}

		private function _initPositions():void {
			_positions = new Array();
			var i:int;
			for (i = 0; i < 8; i++ ) {
				_positions[i] = new Array();
				for (var j:int = 2; j < 6; j++ ) {
					_positions[i][j] = { 
						'figureName' : null,
						'color' : null
					};
				}
			}
			for (i = 0; i < 8; i++ ) {
				_positions[i][1] = {
					figureName : getNameByCoord(FIGURE_PAWN, i, 1),
					color : WHITE
				};
				_positions[i][6] = {
					figureName : getNameByCoord(FIGURE_PAWN, i, 6),
					color : BLACK
				};
				
			}
			
			var figures:Array = [FIGURE_ROOK, FIGURE_KNIGHT, FIGURE_BISHOP];
			for (i = 0; i < figures.length; i++ ) {
				_positions[7-i][7] = {
					figureName : getNameByCoord(figures[i], 7-i, 7),
					color : BLACK
				};
				_positions[i][7] = {
					figureName : getNameByCoord(figures[i], i, 7),
					color : BLACK
				};
			}
			_positions[3][7] = {
				figureName : getNameByCoord(FIGURE_QUEEN, 3, 7),
				color : BLACK
			};
			_positions[4][7] = {
				figureName : getNameByCoord(FIGURE_KING, 4, 7),
				color : BLACK
			};

			for (i = 0; i < figures.length; i++ ) {
				_positions[7-i][0] = {
					figureName : getNameByCoord(figures[i], 7-i, 0),
					color : WHITE
				};
				_positions[i][0] = {
					figureName : getNameByCoord(figures[i], i, 0),
					color : WHITE
				};
			}
			_positions[3][0] = {
				figureName : getNameByCoord(FIGURE_QUEEN, 3, 0),
				color : WHITE
			};
			_positions[4][0] = {
				figureName : getNameByCoord(FIGURE_KING, 4, 0),
				color : WHITE
			};
			
			_selected = null;
			_currentPlayer = WHITE;
		}
		
		private function isEmptyField(x:int, y:int):Boolean {
			return !_positions[x][y].color;
		}
		
		private function isEnemyFigure(x:int, y:int):Boolean {
			return _positions[x][y].color && _positions[x][y].color != _currentPlayer;
		}
		
		private function isMyFigure(x:int, y:int):Boolean {
			return _positions[x][y].color && _positions[x][y].color === _currentPlayer;
		}
		
		private function getEnemyPlayer():String {
			return (_currentPlayer == WHITE ? BLACK : WHITE);
		}

		private function checkPawnUpgrade():void {
			if (_selected.type == FIGURE_PAWN &&(_selected.y == 7 || _selected.y == 0)) {
				var choosenFigure:String = callGetFigureUpgradePawn();
				var x:int = -1;
				switch(choosenFigure) {
					case FIGURE_QUEEN: x = 3; break;
				}
				var y:int = (_currentPlayer == WHITE ? 0 : 7);
				callHideFigure(_selected.figureName);
				var choosenFigureName:String = choosenFigure + '_' + x + '_' + y;
				var newFigureName:String = choosenFigure +'_' + _selected.figureName;
				callCloneFigure(
						choosenFigureName, 
						newFigureName, 
						_selected.x, 
						_selected.y
				);
				_positions[_selected.x][_selected.y].figureName = newFigureName;
			}
		}
		
		private function move(x:int, y:int):void {
			//jesli zaznaczony i moze sie tutaj ruszyc
				//jesli nie ma koloru - przejdz na pozycje
				//jesli moj kolor - zmien selected
				//jesli color przeciwnika - zbij, selected odznacz, zmien ture
			//niezaznaczony
				//jesli jest parametr figure i tura color to zaznacz
			CONFIG::debug { trace('move 1 '+JSON.stringify(_positions[x][y])); }
			if (canMoveSelected(x, y)) {
				CONFIG::debug { trace('move 2'+JSON.stringify(_positions[x][y])); }
				if (isEnemyFigure(x, y)) {
					callHideFigure(_positions[x][y].figureName);
					CONFIG::debug { trace('move 5'); }
					_positions[_selected.x][_selected.y] = { 'figureName' : null, 'color' : null };
					_positions[x][y] = { 'figureName' : _selected.figureName, 'color' : _selected.color };
					callMoveFigure(_selected.figureName, x, y);
					nextPlayer();
				} else if(isEmptyField(x, y)) {
					CONFIG::debug { trace('move 8'); }
					_positions[_selected.x][_selected.y] = { 'figureName' : null, 'color' : null };
					_positions[x][y] = { 'figureName' : _selected.figureName, 'color' : _selected.color };
					callMoveFigure(_selected.figureName, x, y);
					nextPlayer();
				}
			}
			CONFIG::debug { trace('move 10'); }
		}
		
		private function isFrozen(x:int, y:int):Boolean {
			return false;
		}
		
		private function nextPlayer():void {
			if (_currentPlayer === BLACK) {
				_currentPlayer = WHITE;
				CONFIG::debug { trace('move 6'); }
			}else {
				_currentPlayer = BLACK;
				CONFIG::debug { trace('move 7'); }
			}
			if (_pawnOmmitField[_currentPlayer]) {
				cleanField(_pawnOmmitField[_currentPlayer].x, _pawnOmmitField[_currentPlayer].y)
				_pawnOmmitField[_currentPlayer] = null;
			}
			_selected = null;
		}
		
		public function cleanField(x:int, y:int):void {
			_positions[x][y].figureName = null;
			_positions[x][y].color = null;
		}
		
		private function canMoveSelected(x:int, y:int):Boolean {
			//jezeli nie zaznaczono lub zaznaczone te same pole
			if (!_selected || (x === _selected.x && y === _selected.y)) 
				return false;
			
			CONFIG::debug { trace('canMove_selected '+_selected.type+' (' + _selected.x + ',' + _selected.y + ') => (' + x + ',' + y + ')'); }
			switch(_selected.type) {
				case "Pawn" :
					var direction:int = (_currentPlayer == WHITE ? 1 : -1);
					
					CONFIG::debug { trace('canMove_selected Pawn 1'); }
					var success:Boolean = false;
					//walidacja
					
					//wykonano ruch do przodu
					if (x == _selected.x) {
						CONFIG::debug { 
							trace('canMove_selected Pawn 2 ', 
								y, _selected.y + (2 * direction), 
								_selected.y + (1 * direction), 
								isEmptyField(x, y)
							); 
						}
						//wykonano ruch o jedno pole do przodu
						//sprawdz czy nie ma pionka na polu
						if ((y == _selected.y + (1*direction)) && isEmptyField(x, y)) {
							success = true;

						//wykonano ruch o dwa pola do przodu
						//sprawdz czy pionek jest w pierwszej linii, nie ma pionka na polach
						}else if (y == _selected.y + (2*direction) && (_selected.y - direction) % 7 == 0 && isEmptyField(x, y) && isEmptyField(x, y-(1*direction))) {
							//ustaw flage pominiecia pola
							var ommitY:int = y - (1 * direction);
							_positions[x][ommitY].figureName = 'Ommit';
							_positions[x][ommitY].color = _selected.color;
							_pawnOmmitField[_currentPlayer] = { 'x' : x, 'y' : ommitY };
							CONFIG::debug { trace('canMove_selected Pawn 3 '); }
							success = true;
						}
						
					//wykonano bicie
					}else if ((x == _selected.x - 1 && x >= 0) || (x == _selected.x + 1 && x < 8)) {
							CONFIG::debug { trace('canMove_selected Pawn 4 '+JSON.stringify(_pawnOmmitField)); }
						//sprawdz czy na polu jest figura przeciwnika
						if (isEnemyFigure(x, y)) {
							CONFIG::debug { trace('canMove_selected Pawn 5 '+JSON.stringify(_positions[x][y])); }
							// jezeli jest tu flaga pominiecia pola - cofnij pionek ktory pominal pole
							if (_positions[x][y].figureName == 'Ommit') {
								var ommitPawnY:int = y - direction;
								_positions[x][y].figureName = _positions[x][ommitPawnY].figureName;
								_positions[x][ommitPawnY].figureName = null;
								_positions[x][ommitPawnY].color = null;
								_pawnOmmitField[getEnemyPlayer()] = null;
							}
							CONFIG::debug { trace('canMove_selected Pawn 6 '+JSON.stringify(_positions[x][y])); }
							success = true;
						}
					}
					if (success) {
						checkPawnUpgrade();
					}
					CONFIG::debug { trace('canMove_selected ' + success); }
					return success;
				case "King" : 
					return (Math.abs(x - _selected.x) <= 1 && Math.abs(y - _selected.y) <= 1 );
				case "Bishop" : 
					return Math.abs(x - _selected.x) ===  Math.abs(y - _selected.y);
				
			}
			return false;
		}
		
		public function getNameByCoord(type:String, x:int, y:int):String {
			return type + '_' + x + '_' + y;
		}
	}

}