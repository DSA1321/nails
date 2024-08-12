﻿Функция ПолучитьСтатьюЗатрат(Номенклатура) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.СтатьяЗатрат;
КонецФункции
