﻿
Процедура ДеревоТиповСловаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Уровень() = 1 Тогда
		Закрыть(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора <> Неопределено Тогда
		ЭлементыФормы.ДеревоТиповСлова.ТекущаяСтрока = НачальноеЗначениеВыбора;
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ФормаВыбораСправкиПоСлову");
