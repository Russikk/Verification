# Налаштування Cadence Xcelium
TOOL = xrun
# Прапорці для запуску: filelist, доступ до сигналів та збір покриття
FLAGS = -f filelist.f -gui -access +rwc -coverage all -sv

# Команда за замовчуванням
all: run

# Запуск симуляції
run:
	$(TOOL) $(FLAGS) top.sv

# Очищення проекту від тимчасових файлів симулятора
clean:
	rm -rf xcelium.d xmsim.log xrun.history xrun.log
	rm -rf waves.shm cov_work .simvision
	rm -f dump.vcd
	@echo "Project cleaned."
