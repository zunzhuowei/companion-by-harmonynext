import { preferences } from '@kit.ArkData';

const name = 'userData'

class PreferencesUtils {
  static async get(key: string, valueType: preferences.ValueType) {
    try {
      const context: Context = getContext();
      const prefs: preferences.Preferences = await preferences.getPreferences(context, name);
      let res = await prefs.get(key, valueType);
      console.log('get res:', res)
      return res;
    } catch (e) {
      console.error(e)
      return valueType;
    }
  }

  static async set(key: string, valueType: preferences.ValueType) {
    try {
      const context: Context = getContext();
      const prefs: preferences.Preferences = await preferences.getPreferences(context, name);
      await prefs.put(key, valueType);
      await prefs.flush()
      console.log('set res:', key)
    } catch (e) {
      console.error(e)
    }
  }

  static async delete(key: string) {
    try {
      const context: Context = getContext();
      const prefs: preferences.Preferences = await preferences.getPreferences(context, name);
      await prefs.delete(key);
      await prefs.flush()
      console.log('delete res:', key)
    } catch (e) {
      console.error(e)
    }
  }
}

export default PreferencesUtils