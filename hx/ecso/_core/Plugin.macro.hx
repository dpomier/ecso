package ecso._core;

import haxe.macro.Context;
import haxe.PosInfos;

using haxe.io.Path;

private typedef EcsoPluginApi = {
	function init():Void;
}

class Plugin {
	@:persistent static var plugin(get, default):EcsoPluginApi;

	static function init():Void {
		if (#if display true || #end Context.defined('display'))
			return;

		plugin.init();
	}

	static function get_plugin():EcsoPluginApi {
		return if (plugin == null) {
			try {
				plugin = eval.vm.Context.loadPlugin(getPluginPath());
			} catch (e:String) {
				throw '[ECSO] Failed to load plugin: $e';
			}
		} else {
			plugin;
		}
	}

	static function getPluginPath():String {
		final thisFile = (function(?p:PosInfos) return p.fileName)();
		final srcDir = thisFile.directory().directory().directory().directory();
		final system = switch Sys.systemName() {
			case "Windows":
				final wmic = new sys.io.Process("WMIC OS GET osarchitecture /value");
				final arch = switch wmic.stdout.readAll().toString() {
					case v if (v.indexOf("64") >= 0):
						"64";
					case v if (v.indexOf("32") >= 0):
						"32";
					case _:
						Context.warning("{ECSO} failed to resolve your processor architecture - please report this at https://github.com/EcsoKit/ecso/issues", Context.currentPos());
						"64";
				}
				wmic.close();
				'Windows$arch';
			case s:
				s;
		}
		return Path.join([srcDir, 'cmxs', system, 'plugin.cmxs']);
	}
}
