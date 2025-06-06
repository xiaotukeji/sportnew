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
                
                <el-form-item :label="t('baseItemId')" prop="base_item_id">
                    <el-input v-model="formData.base_item_id" clearable :placeholder="t('baseItemIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('categoryId')" prop="category_id">
                    <el-input v-model="formData.category_id" clearable :placeholder="t('categoryIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('name')" prop="name">
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('competitionType')" prop="competition_type">
                    <el-input v-model="formData.competition_type" clearable :placeholder="t('competitionTypePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('genderType')" prop="gender_type">
                    <el-input v-model="formData.gender_type" clearable :placeholder="t('genderTypePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('ageGroup')" >
                    <el-input v-model="formData.age_group" clearable :placeholder="t('ageGroupPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('maxParticipants')" >
                    <el-input v-model="formData.max_participants" clearable :placeholder="t('maxParticipantsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('minParticipants')" >
                    <el-input v-model="formData.min_participants" clearable :placeholder="t('minParticipantsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('registrationFee')" >
                    <el-input v-model="formData.registration_fee" clearable :placeholder="t('registrationFeePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('rules')" >
                    <el-input v-model="formData.rules" clearable :placeholder="t('rulesPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('equipment')" >
                    <el-input v-model="formData.equipment" clearable :placeholder="t('equipmentPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('venueRequirements')" >
                    <el-input v-model="formData.venue_requirements" clearable :placeholder="t('venueRequirementsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('refereeRequirements')" >
                    <el-input v-model="formData.referee_requirements" clearable :placeholder="t('refereeRequirementsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('sort')" prop="sort">
                    <el-input v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')" class="input-width" />
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
import { getSportItemInfo,addSportItem,editSportItem } from '@/addon/sport/api/sport_item';
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
    base_item_id: 0,
    category_id: 0,
    name: '',
    competition_type: 0,
    gender_type: 0,
    age_group: '',
    max_participants: 0,
    min_participants: 0,
    registration_fee: '',
    rules: '',
    equipment: '',
    venue_requirements: '',
    referee_requirements: '',
    sort: 0,
    status: 0,
    remark: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getSportItemInfo(id)).data
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
    base_item_id: [
        { required: true, message: t('baseItemIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    category_id: [
        { required: true, message: t('categoryIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    competition_type: [
        { required: true, message: t('competitionTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    gender_type: [
        { required: true, message: t('genderTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    age_group: [
        { required: true, message: t('ageGroupPlaceholder'), trigger: 'blur' },
        
    ]
,
    max_participants: [
        { required: true, message: t('maxParticipantsPlaceholder'), trigger: 'blur' },
        
    ]
,
    min_participants: [
        { required: true, message: t('minParticipantsPlaceholder'), trigger: 'blur' },
        
    ]
,
    registration_fee: [
        { required: true, message: t('registrationFeePlaceholder'), trigger: 'blur' },
        
    ]
,
    rules: [
        { required: true, message: t('rulesPlaceholder'), trigger: 'blur' },
        
    ]
,
    equipment: [
        { required: true, message: t('equipmentPlaceholder'), trigger: 'blur' },
        
    ]
,
    venue_requirements: [
        { required: true, message: t('venueRequirementsPlaceholder'), trigger: 'blur' },
        
    ]
,
    referee_requirements: [
        { required: true, message: t('refereeRequirementsPlaceholder'), trigger: 'blur' },
        
    ]
,
    sort: [
        { required: true, message: t('sortPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
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

           const save = id ? editSportItem : addSportItem
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
