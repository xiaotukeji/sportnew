<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportOrganizer') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportOrganizerTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('organizerId')" prop="organizer_id">
                        <el-input v-model="sportOrganizerTable.searchParam.organizer_id" :placeholder="t('organizerIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-input v-model="sportOrganizerTable.searchParam.member_id" :placeholder="t('memberIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerType')" prop="organizer_type">
                        <el-input v-model="sportOrganizerTable.searchParam.organizer_type" :placeholder="t('organizerTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerName')" prop="organizer_name">
                        <el-input v-model="sportOrganizerTable.searchParam.organizer_name" :placeholder="t('organizerNamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerLicense')" prop="organizer_license">
                        <el-input v-model="sportOrganizerTable.searchParam.organizer_license" :placeholder="t('organizerLicensePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('contactName')" prop="contact_name">
                        <el-input v-model="sportOrganizerTable.searchParam.contact_name" :placeholder="t('contactNamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('contactPhone')" prop="contact_phone">
                        <el-input v-model="sportOrganizerTable.searchParam.contact_phone" :placeholder="t('contactPhonePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportOrganizerTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportOrganizerTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportOrganizerTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportOrganizerTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportOrganizerTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportOrganizerList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportOrganizerTable.data" size="large" v-loading="sportOrganizerTable.loading">
                    <template #empty>
                        <span>{{ !sportOrganizerTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="organizer_id" :label="t('organizerId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="member_id" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_type" :label="t('organizerType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_name" :label="t('organizerName')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_license" :label="t('organizerLicense')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="contact_name" :label="t('contactName')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="contact_phone" :label="t('contactPhone')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportOrganizerTable.page" v-model:page-size="sportOrganizerTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportOrganizerTable.total"
                        @size-change="loadSportOrganizerList()" @current-change="loadSportOrganizerList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportOrganizerList, deleteSportOrganizer } from '@/addon/sport/api/sport_organizer'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportOrganizerTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "organizer_id":"",
      "member_id":"",
      "organizer_type":"",
      "organizer_name":"",
      "organizer_license":"",
      "contact_name":"",
      "contact_phone":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取主办方列表
 */
const loadSportOrganizerList = (page: number = 1) => {
    sportOrganizerTable.loading = true
    sportOrganizerTable.page = page

    getSportOrganizerList({
        page: sportOrganizerTable.page,
        limit: sportOrganizerTable.limit,
         ...sportOrganizerTable.searchParam
    }).then(res => {
        sportOrganizerTable.loading = false
        sportOrganizerTable.data = res.data.data
        sportOrganizerTable.total = res.data.total
    }).catch(() => {
        sportOrganizerTable.loading = false
    })
}
loadSportOrganizerList()

const router = useRouter()

/**
 * 添加主办方
 */
const addEvent = () => {
    router.push('/sport_organizer/sport_organizer_edit')
}

/**
 * 编辑主办方
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_organizer/sport_organizer_edit?id='+data.id)
}

/**
 * 删除主办方
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportOrganizerDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportOrganizer(id).then(() => {
            loadSportOrganizerList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportOrganizerList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
