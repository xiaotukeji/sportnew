<template>
    <div class="main-container">
        <div class="detail-head">
            <div class="left" @click="back()">
                <span class="iconfont iconxiangzuojiantou !text-xs"></span>
                <span class="ml-[1px]">{{t('returnToPreviousPage')}}</span>
            </div>
            <span class="adorn">|</span>
            <span class="right">{{ pageName }}</span>
        </div>
        <el-card class="box-card !border-none" shadow="never">
            <el-form :model="formData" label-width="90px" ref="formRef" :rules="formRules" class="page-form">
                <el-form-item :label="t('eventId')" prop="event_id">
                    <el-input v-model="formData.event_id" clearable :placeholder="t('eventIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('itemId')" prop="item_id">
                    <el-input v-model="formData.item_id" clearable :placeholder="t('itemIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('athleteId')" prop="athlete_id">
                    <el-input v-model="formData.athlete_id" clearable :placeholder="t('athleteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('teamId')" prop="team_id">
                    <el-input v-model="formData.team_id" clearable :placeholder="t('teamIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('registrationType')" prop="registration_type">
                    <el-input v-model="formData.registration_type" clearable :placeholder="t('registrationTypePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('registrationTime')" prop="registration_time">
                    <el-input v-model="formData.registration_time" clearable :placeholder="t('registrationTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('status')" prop="status">
                    <el-radio-group  v-model="formData.status" :placeholder="t('statusPlaceholder')">
                        <el-radio
                            v-for="(item, index) in statusList"
                            :key="index" :label="item.value">
                              {{ item.name }}
                        </el-radio>
                    </el-radio-group>
                </el-form-item>
                
                <el-form-item :label="t('paymentStatus')" prop="payment_status">
                    <el-input v-model="formData.payment_status" clearable :placeholder="t('paymentStatusPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('paymentTime')" >
                    <el-input v-model="formData.payment_time" clearable :placeholder="t('paymentTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('sort')" prop="sort">
                    <el-input v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('remark')" >
                    <el-input v-model="formData.remark" clearable :placeholder="t('remarkPlaceholder')" class="input-width" />
                </el-form-item>
                
            </el-form>
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import type { FormInstance } from 'element-plus'
import { getSportRegistrationInfo,addSportRegistration,editSportRegistration } from '@/addon/sport/api/sport_registration';
import { useRoute } from 'vue-router'

const route = useRoute()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title



/**
 * 表单数据
 */
const initialFormData = {
    id: 0,
    event_id: 0,
    item_id: 0,
    athlete_id: 0,
    team_id: 0,
    registration_type: 0,
    registration_time: 0,
    status: 0,
    payment_status: 0,
    payment_time: 0,
    sort: 0,
    remark: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getSportRegistrationInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if(id) setFormData(id);

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    let statusList = ref([])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();
    watch(() => statusList.value, () => { formData.status = statusList.value[0].value })

    
// 表单验证规则
const formRules = computed(() => {
    return {
    event_id: [
        { required: true, message: t('eventIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    item_id: [
        { required: true, message: t('itemIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    athlete_id: [
        { required: true, message: t('athleteIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    team_id: [
        { required: true, message: t('teamIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    registration_type: [
        { required: true, message: t('registrationTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    registration_time: [
        { required: true, message: t('registrationTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    payment_status: [
        { required: true, message: t('paymentStatusPlaceholder'), trigger: 'blur' },
        
    ]
,
    payment_time: [
        { required: true, message: t('paymentTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    sort: [
        { required: true, message: t('sortPlaceholder'), trigger: 'blur' },
        
    ]
,
    remark: [
        { required: true, message: t('remarkPlaceholder'), trigger: 'blur' },
        
    ]

    }
})

const onSave = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
       if (valid) {
           loading.value = true
           let data = formData

           const save = id ? editSportRegistration : addSportRegistration
           save(data).then(res => {
               loading.value = false
               history.back()
           }).catch(err => {
               loading.value = false
           })

       }
    })
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}


// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
    if (!Number.isInteger(value)) {
        callback(new Error(t('generateNumber')))
    } else {
        callback()
    }
}
const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped></style>
